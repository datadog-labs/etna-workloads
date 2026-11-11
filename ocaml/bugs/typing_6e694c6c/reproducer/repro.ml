type (_,_) eql = Refl : ('a, 'a) eql
type s = x:int -> y:float -> unit
type t = y:int -> x:float -> unit
type silly = {silly: 'a.'a}
let f : [`L of (s, t) eql | `R of silly] -> 'a =
  function `R {silly} -> silly
