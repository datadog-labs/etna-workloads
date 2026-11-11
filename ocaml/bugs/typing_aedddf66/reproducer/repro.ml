module T7 : sig end = struct
  module M = struct
    class type t = object end
  end
  module type S = sig
    open M
    val f: #t -> unit
  end
  let _ = fun ((module S : S)) -> S.f (object end)
end
