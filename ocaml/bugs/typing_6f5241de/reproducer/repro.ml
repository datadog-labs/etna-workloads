exception A
type a = A
let f = function Not_found -> 1 | A -> 2 | _ -> 3
let _ = f
