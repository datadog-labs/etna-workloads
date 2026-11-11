let r = ref None
module M : sig
  val write : ([< `A of string | `B of int ] -> unit)
end = struct
  let write x =
    match x with `A _ | `B _ -> r := Some x
end
