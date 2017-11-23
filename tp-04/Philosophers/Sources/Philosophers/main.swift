import PetriKit
import PhilosophersLib

// Nom : Jonathan Lo
// Cours : Outils Formels De Modelisation
// TP 4
// Date : Novembre 2017

// Exemple
do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C { // Les fonctions
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]), // [.variable("x")] est un multiset
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]), // Le label est sur la fonction g
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []] // Fabrication du marquage initial
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()


// Pour 3 philosophes (non blocable):
print("Pour 3 philosophes (non blocable) :")
do {
    let philosophers = lockFreePhilosophers(n: 3)
    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
    let markingGraph = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("Le nombre de marquages posssibles dans le modele des philosophes non blocable a 3 philosphes est :",markingGraph!.count)
}
print()

// Question 1
// Reponse : Le nombre de marquages posssibles dans le modele des philosophes non blocable a 5 philosphes est 11.
print("QUESTION 1")
// Pour 5 philosophes (non blocable) :
print("Pour 5 philosophes (non blocable) :")
do {
    let philosophers = lockFreePhilosophers(n: 5)
    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
    print(philosophers.initialMarking!)
    let markingGraph_lockFree = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("Le nombre de marquages posssibles dans le modele des philosophes non blocable a 5 philosphes est :",markingGraph_lockFree!.count)
}
print()

// Question 2
// Reponse : Le nombre de marquages posssibles dans le modele des philosophes blocable a 5 philosphes est 82.
print("QUESTION 2")
// Pour 5 philosophes (blocable) :
print("Pour 5 philosophes (blocable) :")
do {
    let philosophers = lockablePhilosophers(n: 5)
    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
    print(philosophers.initialMarking!)
    let markingGraph_lockable = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("Le nombre de marquages posssibles dans le modele des philosophes blocable a 5 philosphes est :",markingGraph_lockable!.count)
    print()


// Question 3
// Voici plusieurs exemples d'etat ou le reseau est bloque dans le modele des philosophes bloquable a 5 philosophes :
    print("QUESTION 3")
    for element in markingGraph_lockable! {
      if (element.successors.count == 0){ // Si le nombre de successeurs est egal a 0
        print("Voici un exemple d'etat ou le reseau est bloque dans le modele des philosophes bloquable a 5 philosophes :")
        print(element.marking) // On affiche
        break
      }
    }

}
