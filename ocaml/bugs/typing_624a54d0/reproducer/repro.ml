module M : sig
  type (_, _) t
  val f : (_, _) t -> unit
end = struct
  type _ t
  let f _ = ()
end
