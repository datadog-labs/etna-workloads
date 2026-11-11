module Other = struct type t = { y : int } end
type inner = { x : int }
type outer = inner
let f (r : outer) = r.Other.y
