import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Write here the implementation of the coverability graph generation.

        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.

        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.

	// Cette fonction retourne un element du type CoverabilityGraph
	
	let m = marking // C'est le marquage initial
	let m0 = CoverabilityGraph(marking: m) // C'est le CoverabilityGraph initial
	var next = [CoverabilityGraph]() // Tableau contenant les prochains elements a analyser
	next.insert(m0, at: 0) // Nous mettons le CoverabilityGraph initial dans la liste de ceux a analyser
	var seen = [CoverabilityGraph]() // Tableau vide pour stocker les elements deja analyse
	
	// Nous parcourons les CoverabilityGraph :
	

        return CoverabilityGraph(marking: marking)
    }

}
