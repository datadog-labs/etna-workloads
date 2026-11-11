module I : sig
  module F (_ : sig val test : int end) : sig end
end = struct
 module F (X: sig val test : int end) = struct let _ = X.test end
end
