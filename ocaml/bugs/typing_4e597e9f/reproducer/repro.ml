type u = int * int
type v = float * float
let g (_:u -> unit) = ()
let f (g: u -> unit) = (g: u -> unit :> v -> unit)
