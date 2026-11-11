module type S = sig val y : int end
module M : S = struct let y = 36 end
module N : sig val y : int end = struct let y = 2 end
let _ = (module N : S)
