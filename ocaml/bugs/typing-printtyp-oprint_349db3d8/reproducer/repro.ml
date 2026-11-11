module M = struct
  type t = A
  module M : sig
    val f : t -> unit
  end = struct
    type t = B
    let f B = ()
  end
end
