/*********************************************
 * OPL 12.6.3.0 Model
 * Author: patrickmesana
 * Creation Date: 2016-03-18 at 3:48:03 PM
 *********************************************/

 int nbrSites = ...;
 int nbrClients = ...;
 range sites = 1..nbrSites;
 range clients = 1..nbrClients;
 int nbrDeFranchisesAOuvrir = ...;
 int clientsDesservisMin = ...;
 int clientsDesservisMax = ...;
 float DistanceCS[clients][sites] = ... ;
 float DistanceSS[sites][sites] = ... ;


// ***********************
// Variables de decision
// ***********************
dvar boolean x[sites]; //vaut 1 si la franchise est choisi, 0 sinon
dvar boolean y[clients][sites]; //vaut 1 si le client i est desservi par la franchise j, 0 sinon
dvar boolean z[sites][sites];//vaut 1 quand les deux sites sont ouverts

// ***********************
// Fonction-objectif
// ***********************
maximize sum (s1 in sites, s2 in sites) DistanceSS[s1][s2] * z[s1][s2];
 
// ***********************
// Expressions
// *********************** 
dexpr int nbrDeClientsDeservisParLeSite[s in sites] = sum (c in clients) y[c][s]; 
dexpr int nbrDeSitesQuiDeserveLeClient[c in clients] = sum (s in sites) y[c][s]; 
dexpr int nbrDeSitesOuverts = sum(s in sites) x[s];
 
// ***********************
// Contraintes
// ***********************
subject to {
	//Nbr de franchise a ouvrir
	 nbrDeSitesOuverts == nbrDeFranchisesAOuvrir;
	
	//Tous les clients doivent etre desservi au moins 1 fois
	forall (c in clients) nbrDeSitesQuiDeserveLeClient[c] >= 1;
		
	//Un site doit desservir dans un certain range et 
	//Si le site n'est pas ouvert les clients ne peuvent pas etre desservi par ce site
	forall (s in sites) {	
		nbrDeClientsDeservisParLeSite[s] >= clientsDesservisMin * x[s];
		nbrDeClientsDeservisParLeSite[s] <= clientsDesservisMax * x[s];	
	}
	
	forall (s1 in sites, s2 in sites) {
		 z[s1][s2] == 1 => (x[s1] == 1 && x[s2] == 1);
		 z[s1][s2] == 0 => (x[s1] == 0 || x[s2] == 0);
	}
	
}