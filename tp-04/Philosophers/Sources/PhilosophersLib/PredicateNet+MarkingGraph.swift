extension PredicateNet {

// Nom : Jonathan Lo
// Cours : Outils Formels De Modelisation
// TP 4
// Date : Novembre 2017


    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
	      // Cette fonction prend en parametre un type MarkingType et retourne un type PredicateMarkingNode<T>

        // Write your code here ...

        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.
	let m = marking
	let m0 = PredicateMarkingNode<T>(marking : m, successors:[:]) // Il s'agit du graphe de marquage d'un reseau Petri de type Predicate-Net
	var next = [PredicateMarkingNode<T>]() // C'est la liste des prochains elements que l'on va analyser
	next.insert(m0, at:0) // Nous mettons m0 dans cette liste
	var seen = [PredicateMarkingNode<T>]() // C'est la liste des elements que l'on a deja analyser
	seen.insert(m0, at:0) // On met m0 dans cette liste
	var tab_b = [PredicateTransition<T>.Binding]() // Ce sera pour les bindings

	while !(next.isEmpty){ // Tant que la liste des elements a analyser n'est pas vide, on boucle
		let mg = next.popLast() // On recupere dans mg la derniere valeur de next
		seen.append(mg!) // On place mg dans seen car on l'analyse maintenant

		for oneTransition in self.transitions{ // Nous parcourons les transitions
			tab_b = oneTransition.fireableBingings(from: mg!.marking) // On s'occupe des bindings
			var newBinding : PredicateBindingMap<T> = [:] // On declare une variable du type PredicateBindingMap<T>

			for one_b in tab_b{
				if (oneTransition.fire(from: mg!.marking, with: one_b) != nil) { // Si le tir donne un resultat, on execute la suite
					let newM = PredicateMarkingNode<T>(marking:oneTransition.fire(from: mg!.marking, with: one_b)! , successors:[:]) // De meme type que m0
					if (seen.contains(where: {PredicateNet.greater(newM.marking, $0.marking)}) == true){ // Dans le cas ou c'est dans la liste des marquages deja analyse
					return nil
					}
					if (seen.contains(where: {PredicateNet.equals(newM.marking, $0.marking)}) == false){ // Dans le cas ou ce n'est pas dans la liste des marquages deja analyses
						next.append(newM) // newM est place dans la liste des elements a analyser
						seen.append(newM) // On met newM dans la liste des elements deja analyses
						newBinding[one_b] = newM
						mg!.successors.updateValue(newBinding, forKey: oneTransition) // On met a jour les successeurs de mg grace a updateValue()
					}
				}
			}
		}
	}
        return m0 // On retourne le graphe de marquage
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard rhs[place]!.contains(t) else { return false }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.contains(t) else { return false }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
