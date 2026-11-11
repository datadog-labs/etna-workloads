type 'e opt = 'e option constraint 'e = [> `A ]
let f: unit -> [> `A] opt = fun () -> None
let x = f ()
