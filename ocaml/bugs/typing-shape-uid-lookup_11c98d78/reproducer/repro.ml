type e = ..
module type T = sig
  type s = A | B of { r:unit }
  type r = { x:unit }
  type e += E
end
module I (X:T) = struct
  let x = X.A
  let y = X.B { r = () }
  let z = { X.x = () }
  let w = X.E
end
