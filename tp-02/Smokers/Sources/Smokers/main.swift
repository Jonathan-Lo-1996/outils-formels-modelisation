import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" }) // J'ai ajoute la virgule ici

	/*
	// Ajout des transitions :
	let tpt = model.transitions.first(where: { $0.name == "tpt" }),
	let tpm = model.transitions.first(where: { $0.name == "tpm" }),
	let ttm = model.transitions.first(where: { $0.name == "ttm" }),
	let ts1 = model.transitions.first(where: { $0.name == "ts1" }),
	let ts2 = model.transitions.first(where: { $0.name == "ts2" }),
	let ts3 = model.transitions.first(where: { $0.name == "ts3" }),
	let tw1 = model.transitions.first(where: { $0.name == "tw1" }),
	let tw2 = model.transitions.first(where: { $0.name == "tw2" }),
	let tw3 = model.transitions.first(where: { $0.name == "tw3" })
	*/

else {
    fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).

// Voici la fonction permettant de compter le nombre d'etat : (Nous l'avions ecrite lors de la seance d'exercice 5)

func countNodes(markingGraph: MarkingGraph) -> Int {
	var seen = [markingGraph] // deja visite
	var toVisit = [markingGraph] // encore a visiter

	// current est le markingGraph que nous traitons a chaque iteration de la boucle while
	while let current = toVisit.popLast(){
		
		for (_, successors) in current.successors { // Nous iterons sur les successeurs
			if !seen.contains(where: {$0 === successors}){
				// Si l'element n'est pas dans le tableau seen on fait :
				seen.append(successors)
				toVisit.append(successors)
			}
		}
	}
	return seen.count // retourne le nombre d'element du tableau seen (c'est a dire le nombre de markingGraph)
}

// Fonction qui nous retourne un type booleen pour nous dire si c'est possible d'avoir deux personnes qui fument en meme temps :
// C'est une fonction similaire a celle que nous avons ecrite lors de la seance d'exercice 5

func FumeurDouble (to markingGraph: MarkingGraph) -> Bool{
	var seen = [markingGraph] // deja visite
	var toVisit = [markingGraph] // pas encore visite

	// current est le markingGraph que nous traitons a chaque iteration de la boucle while
	while let current = toVisit.popLast(){

		for (_,successor) in current.successors{ // Nous iterons sur les successeurs
			if !seen.contains(where: {$0 === successor}){
				seen.append(successor)
				toVisit.append(successor)
				if (successor.marking[s1]==1 && successor.marking[s2]==1){
					// Si s1 et s2 fument en meme temps
					return true
				}else if (successor.marking[s2]==1 && successor.marking[s3]==1){
					// Si s2 et s3 fument en meme temps
					return true
				}else if (successor.marking[s1]==1 && successor.marking[s3]==1){
					// Si s1 et s3 fument en meme temps
					return true
				}
			}
		}
	}
	return false
}


// Fonction qui nous retourne un type booleen pour nous dire si c'est possible d'avoir deux fois le meme ingredient sur la table :
// C'est une fonction similaire a celle que nous avons ecrite lors de la seance d'exercice 5

func IngredientsDouble (to markingGraph: MarkingGraph) -> Bool{
	var seen = [markingGraph] // deja visite 
	var toVisit = [markingGraph] // pas encore visite

	// current est le markingGraph que nous traitons a chaque iteration de la boucle while
	while let current = toVisit.popLast(){
		for (_,successor) in current.successors{
			if !seen.contains(where: {$0 === successor}){
				seen.append(successor)
				toVisit.append(successor)
				if (successor.marking[m] == 2){
					// Si nous avons 2 ingredients m sur la table
					return true
				}else if (successor.marking[t] == 2){
					// Si nous avons 2 ingredients t sur la table
					return true
				}else if (successor.marking[p] == 2){
					// Si nous avons 2 ingredients p sur la table
					return true
				}
			}
		}
	}
	return false
}
				
		

if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.


	// Question 1 :

	// Nous avons 32 etats comme le montre la fonction suivante :
	let nombreEtats = countNodes(markingGraph: markingGraph)
	print("Le nombre d'etats est de : ", nombreEtats)


	// Question 2 :

	let fumeur2 = FumeurDouble(to: markingGraph)
	if (fumeur2 == true){
		print("C'est possible d'avoir deux fumeurs en meme temps.")
	}else{
		print("Ce n'est pas possible d'avoir deux fumeurs en meme temps.")
	}


	// Question 3 :

	let ingredients = IngredientsDouble(to: markingGraph)
	if (ingredients == true){
		print("Il est possible d'avoir deux fois le meme ingredient sur la table.")
	}else{
		print("Il n'est pas possible d'avoir deux fois le meme ingredient sur la table.")
	}
}

// Nom : Jonathan Lo
// Cours : Outils Formels De Modelisation
// Date : 20 Octobre 2017
// TP 2
















