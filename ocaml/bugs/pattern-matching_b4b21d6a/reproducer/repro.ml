type t = ..
type t += A of int | B
let f = function (A _ as x) -> ignore x; 1 | B -> 2
