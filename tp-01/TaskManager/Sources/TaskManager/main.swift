import TaskManagerLib

let taskManager = createTaskManager()

// Show here an example of sequence that leads to the described problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...

     let taskPool = taskManager.places.first { $0.name == "taskPool" }!
     let processPool = taskManager.places.first { $0.name == "processPool" }!
     let inProgress = taskManager.places.first { $0.name == "inProgress" }!

     let spawn = taskManager.transitions.first { $0.name == "spawn" }!
     let create = taskManager.transitions.first { $0.name == "create" }!
     let success = taskManager.transitions.first { $0.name == "success" }!
     let fail = taskManager.transitions.first { $0.name == "fail" }!
     let exec = taskManager.transitions.first { $0.name == "exec" }!

// Le probleme que nous rencontrons est le suivant : lorsque nous avons 2 processus dans processPool et une tache dans taskPool,
// deux tirages a la suite de exec nous permettraient d'effectuer la meme tache deux fois avec deux processus differents.
// Donnons un exemple d'execution qui conduit au probleme decrit dans l'enonce :

     // Creation d'une tache
     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
     print(m1!)

     // Apparition d'un processus
     let m2 = spawn.fire(from: m1!)
     print(m2!)

     // Apparition d'un deuxieme processus
     let m3 = spawn.fire(from: m2!)
     print(m3!)

     // 1er execution
     let m4 = exec.fire(from: m3!)
     print(m4!)

     // 2eme execution
     let m5 = exec.fire(from: m4!)
     print(m5!)

     // Tirage d'un succes donc la tache est detruite
     let m6 = success.fire(from: m5!)
     print(m6!)

     // Si nous tirons une deuxieme fois success, nous aurons une erreur car taskPool est vide et donc success n'est plus tirable
     // commande impossible : let m7 = success.fire(from: m6!)
     //                       print(m7!)
// Nous avons maintenant 1 jetons dans inProgress et plus aucun jeton dans taskPool

// Si nous avions beaucoup de processus dans processPool et une seule tache dans taskPool, alors tous les processus pourront un par un executer
// la tache.



let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...

// Maintenant, nous montrons que le probleme est corrige.

     let taskPool02 = correctTaskManager.places.first { $0.name == "taskPool" }!
     let processPool02 = correctTaskManager.places.first { $0.name == "processPool" }!
     let inProgress02 = correctTaskManager.places.first { $0.name == "inProgress" }!
     let limiteur = correctTaskManager.places.first { $0.name == "limiteur" }!

     let spawn02 = correctTaskManager.transitions.first { $0.name == "spawn" }!
     let create02 = correctTaskManager.transitions.first { $0.name == "create" }!
     let success02 = correctTaskManager.transitions.first { $0.name == "success" }!
     let fail02 = correctTaskManager.transitions.first { $0.name == "fail" }!
     let exec02 = correctTaskManager.transitions.first { $0.name == "exec" }!

     // Creation d'une tache
     let m01 = create02.fire(from: [taskPool02: 0, processPool02: 0, inProgress02: 0, limiteur: 1])
     print(m01!)

     // Creation d'une tache
     let m001 = create02.fire(from: m01!)
     print(m001!)

     // Creation d'un processus
     let m02 = spawn02.fire(from: m001!)
     print(m02!)

     // Creation d'un deuxieme processus
     let m03 = spawn02.fire(from: m02!)
     print(m03!)

     // Premiere execution
     let m04 = exec02.fire(from: m03!)
     print(m04!)

     // Nous ne pouvons plus tirer une deuxieme fois exec comme le montre le if suivant
     if (exec02.fire(from: m04!)) == nil{
	print("Cette transition n'est pas franchissable !")
	}

     // La commande let m05 = exec02.fire(from: m04!) provoquerait une erreur car cette transition n'est pas tirable deux fois de suite
     // sans qu'un fail ou un success soit tire une fois

     // Tirage de success qui envoie un jeton dans limiteur (nouvelle place cree) qui permettra a exec d'etre tirable a nouveau
     let m06 = success02.fire(from : m04!)
     print(m06!)

     // Nous pouvons maintenant a nouveau tirer exec car il y a un jeton dans limiteur
     let m07 = exec02.fire(from: m06!)
     print(m07!)
     
     // Donc la correction que nous avons faite nous permet d'empecher que exec ne puisse etre tire une deuxieme fois tant qu'un success ou un fail n'ait ete tire.

// Nom : Jonathan Lo
// Date : Octobre 2017
// TP 1
