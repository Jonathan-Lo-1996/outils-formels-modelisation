import PetriKit

public class MarkingGraph {

// La classe Marking doit contenir deux informations : le marking et les successors :

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
	// La fonction prend en parametre marking qui est de type PTMarking et retourne un resultat de type MarkingGraph.

	let m = marking // C'est le marquage initial
	let m0 = MarkingGraph(marking: m) // C'est le MarkingGraph initial
	var next = [MarkingGraph]() // Tableau contenant les prochains elements a analyser
	next.insert(m0, at: 0) // Nous mettons le MarkingGraph initial dans la liste de ceux a analyser
	var seen = [MarkingGraph]() // Tableau vide pour stocker les elements de type MarkingGraph deja analyse

	// Parcours des MarkingGraph :
	while !(next.isEmpty){ // Tant que le tableau n'est pas vide on fait la boucle
		let mg = next.popLast() // On recupere le dernier element du tableau

		// Nous ajoutons le MarkingGraph a la liste de ceux deja visite :
		seen.append(mg!)
		// Nous parcourons toutes les transitions (pour chaque iteration, oneTransition prend la valeur d'une des transitions)
		for oneTransition in self.transitions {

			// Teste si la transition est tirable :
			if (oneTransition.fire(from: mg!.marking)) != nil { // Une transition non tirable renvoie nil
				
				// Teste si nous avons deja le marquage dans notre tableau des elements deja analyse :
				if seen.contains(where: {$0.marking == oneTransition.fire(from: mg!.marking)!}){
					// Mise a jour des successors :
					mg!.successors[oneTransition]=seen.first(where: {$0.marking == oneTransition.fire(from: mg!.marking)!})
				
				// Teste si nous avons deja le marquage dans notre dans notre tableau des MarkingGraph a analyser :
				}else if next.contains(where: {$0.marking == oneTransition.fire(from: mg!.marking)!}){
					// Mise a jour des successors :
					mg!.successors[oneTransition] = next.first(where: {$0.marking == oneTransition.fire(from: mg!.marking)!})
					
				}else{
				// Cas ou le marquage n'est ni dans next ni dans seen
					let mg2 = MarkingGraph(marking: oneTransition.fire(from: mg!.marking)!)
					next.append(mg2) // Ajout de ce MarkingGraph dans le tableau des MarkingGraph a analyser
					mg!.successors[oneTransition] = mg2 // Mise a jour des successeurs
				}
				 
			}
		}
	}
        return m0 // Nous retournons le MarkingGraph
    }
// Nom : Jonathan Lo
// Cours : Outils Formels De Modelisation
// Date : 20 Octobre 2017
// TP2

}
