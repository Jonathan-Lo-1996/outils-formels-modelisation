infix operator =>: LogicalDisjunctionPrecedence

// Nom : Jonathan Lo
// Cours : Outils Formels De Modelisation
// tp-05
// Date : Decembre 2017

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
        // Write your code here ...

        let proposition_NNF = self.nnf // On applique NNF a la proposition pour eliminer les implications et pour s'occuper des negations

        switch proposition_NNF{

        case .proposition(_):
          return proposition_NNF // On retourne la meme proposition sous forme NNF

        case .negation(let a):
          return (!a).nnf // On retourne la meme proposition sous forme NNF

        case .disjunction(let b, let c):
          return b.dnf || c.dnf // Si c'est une disjonction, on applique dnf a gauche et dnf a droite

        case .conjunction(let b, let c):
          switch b.dnf{ // A gauche du &&
          case .proposition(_):
            break
          case .negation(_):
            break
          case .conjunction(_,_):
            break
          case .disjunction(let d, let e):
            return ((d.dnf && c.dnf) || (e.dnf && c.dnf)).dnf // On applique la regle pour developper la proposition
          case .implication(_,_):
            break
          }
          switch c.dnf{ // A droite du &&
          case .proposition(_):
            break
          case .negation(_):
            break
          case .conjunction(_,_):
            break
          case .disjunction(let d, let e):
            return ((b.dnf && d.dnf) || (b.dnf && e.dnf)).dnf // On applique la regle pour developper la proposition
          case .implication(_,_):
            break
          }
          return proposition_NNF // On retourne la meme proposition sous forme NNF si on n'est dans aucun des cas

        case .implication(_,_):
          return proposition_NNF

        }
    }

    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
        // Write your code here ...

        let proposition_NNF = self.nnf // Nous appliquons la NNF a la proposition pour eliminer les implications et pour s'occuper des negations

        switch proposition_NNF{

        case .proposition(_):
          return proposition_NNF // Retourne la meme proposition sous forme NNF

        case .negation(let a):
          return (!a).nnf // Retourne la meme proposition sous forme NNF

        case .conjunction(let b, let c):
          return (b.cnf && c.cnf) // Si c'est une conjonction, on applique cnf a gauche et cnf a droite

        case .disjunction(let b, let c):
          switch b.cnf{ // A gauche du ||
          case .proposition(_):
            break
          case .negation(_):
            break
          case .conjunction(let d, let e):
            return ((d.cnf || c.cnf) && (e.cnf || c.cnf)).cnf // On applique la regle pour developper la proposition
          case .disjunction(_,_):
            break
          case .implication(_,_):
            break
          }

          switch c.cnf{ // A droite du ||
          case .proposition(_):
            break
          case .negation(_):
            break
          case .conjunction(let d, let e):
            return ((b.cnf || d.cnf) && (b.cnf || e.dnf)).cnf // On applique la regle pour developper la proposition
          case .disjunction(_,_):
            break
          case .implication(_,_):
            break
          }
          return proposition_NNF // On retourne la meme proposition sous forme NNF si on n'est dans aucun des cas

        case .implication(_,_):
          return proposition_NNF


        }
    }

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
