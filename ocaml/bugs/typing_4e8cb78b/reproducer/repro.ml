type t = A : t
module X2 : sig end = struct
  let x = 42
  let _f = function
    | A -> let x = () in x
end
