type t = ..
type t += C of int | D of int * int
let f = function C _ -> 1 | D _ -> 2
