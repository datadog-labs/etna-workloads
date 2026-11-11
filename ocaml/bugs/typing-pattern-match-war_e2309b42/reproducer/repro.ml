module type S = sig val x : int end
let f = function
  | (module M:S),_,(1,_)
  | _,(module M:S),(_,1) when M.x > 0 -> 1
  | _ -> 2
