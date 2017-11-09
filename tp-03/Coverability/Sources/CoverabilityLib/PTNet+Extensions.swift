import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Write here the implementation of the coverability graph generation.

	// La fonction prend en parametre marking qui est de type CoverabilityMarking et retourne un resultat de type CoverabilityGraph.

	let m = marking // Il s'agit du marquage initial
	let m0 = CoverabilityGraph(marking: m) // C'est le CoverabilityGraph initial
	var next = [m0] // Contiendra les prochains elements a analyser
	next.insert(m0, at: 0) // Nous inserons l'element dans la liste
	var seen = [CoverabilityGraph]() // liste des elements deja analyse

	// Nous parcourons sur les elements de next :
	while !(next.isEmpty){ // Tant que ce n'est pas vide nous faisons la boucle
		let mg = next.popLast() // Nous recuperons le dernier element
		// Ajout a la liste des elements deja visite :
		seen.append(mg!)
		let converted = FromCoverabilityMarkingToPTMarking(from: mg!.marking) // Nous effectuons la conversion
		
		// Parcours des transitions :
		for oneTransition in self.transitions {
			// Teste si la transition est tirable :
			if (oneTransition.fire(from: converted)) != nil { 
				var converted2 = FromPTMarkingToCoverabilityMarking(from: oneTransition.fire(from: converted)!) // Nous effectuons une conversion
				for element in m0{
					if converted2 > element.marking{
						for onePlace in self.places{ // Parcours des places
							if converted2[onePlace]! > element.marking[onePlace]!{
								// Si c'est le cas on place le omega
								converted2[onePlace] = .omega
							}
						}
					}
				}
				if seen.contains(where: {$0.marking == converted2}){
					// Mise a jour des successors :
					mg!.successors[oneTransition]=seen.first(where: {$0.marking == converted2})
				
				
				}else if next.contains(where: {$0.marking == converted2}){
					// Mise a jour des successors :
					mg!.successors[oneTransition] = next.first(where: {$0.marking == converted2})
					
				}else{
					let mg2 = CoverabilityGraph(marking: converted2)
					next.append(mg2) // Mise a jour de next
					mg!.successors[oneTransition] = mg2 // Mise a jour des successeurs
				}
				 
			}
		}
	}
        return m0 // Retour de la fonction (de type CoverabilityMarking)
    }






    // Nous creons cette fonction pour pouvoir transformer un objet de type PTMarking en un objet de type CoverabilityMarking :

    public func FromPTMarkingToCoverabilityMarking (from marking: PTMarking) -> CoverabilityMarking {
      var cov : CoverabilityMarking = [:] // Initialisation (de type CoverabilityMarking)
      // Nous parcourons les places :
      for onePlace in self.places{
	// Si le marquage d'une place est superieure a un certain nombre :
        if marking[onePlace]! < 300 {
		cov[onePlace] = .some(marking[onePlace]!) // On est dans le cas ou ce n'est pas superieur
        }else{
		
		cov[onePlace] = .omega // Affectation de omega dans ce cas
        }
      }
      return cov // Retour de la fonction (de type CoverabilityMarking)
    }



    // Nous creons cette fonction pour pouvoir transformer un objet de type CoverabilityMarking en un objet de type PTMarking :

    public func FromCoverabilityMarkingToPTMarking (from marking: CoverabilityMarking) -> PTMarking {

      var mark : PTMarking = [:] // Initialisation (de type PTMarking)
      let start = 0
      let end = 200

      // Nous parcourons les places :
      for onePlace in self.places{
        mark[onePlace] = 300
	// Nous parcourons de start a end :
        for i in start...end{
          if UInt(i) == marking[onePlace]!{
	    // Dans le cas d'egalite :
            mark[onePlace] = UInt(i)
          } // Sinon on ne fait rien
        }
      }
      return mark // Retour de la fonction (de type PTMarking)
    }





// Nom : Lo Jonathan
// Cours : Outils Formels De Modelisation
// TP 03
// Date : Novembre 2017






}
