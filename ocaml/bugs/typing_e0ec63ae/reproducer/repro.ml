module M = struct
  type t = {x:int; y:char}
end
let h (x : M.t) = { x with y = 'a' } :: { x with y = 'b' } :: []
