module T1 = struct
  type t = A
  type s = X
end
module T2 = struct
  type t = T1.t = A
  type s = X
end
module T3 = struct
  open T1
  open T2
  let _ = (A, X)
end
