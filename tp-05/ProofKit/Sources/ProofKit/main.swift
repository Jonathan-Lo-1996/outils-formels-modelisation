import ProofKitLib

// Nom : Jonathan Lo
// Cours : Outils Formels De Modelisation
// tp-05
// Date : Decembre 2017

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"
let e: Formula = "e"
let ff: Formula = "ff"
let g: Formula = "g"
let h: Formula = "h"
let f = a && b

print(f)

// Testons maintenant nos implementations du cnf et du dnf :
print()
print("Testons nos implementations du cnf et du dnf : ")

print("La proposition a tester est : ")
let f_test_1 = (!d) || ((a || b) && (c || g))
print(f_test_1)
print("La proposition sous forme CNF est : ")
print(f_test_1.cnf)
print("La proposition sous forme DNF est : ")
print(f_test_1.dnf)
print()

print("La proposition a tester est : ")
let f_test_2 = (a || d) && (c || !(b || g))
print(f_test_2)
print("La proposition sous forme CNF est : ")
print(f_test_2.cnf)
print("La proposition sous forme DNF est : ")
print(f_test_2.dnf)
print()

print("La proposition a tester est : ")
let f_test_3 = (a || d) => c
print(f_test_3)
print("La proposition sous forme CNF est : ")
print(f_test_3.cnf)
print("La proposition sous forme DNF est : ")
print(f_test_3.dnf)
print()



let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)
