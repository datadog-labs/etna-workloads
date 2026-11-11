module M : sig val f : int -> int [@@deprecated "x"] end = struct let f x = x end
let _ = M.f 1
