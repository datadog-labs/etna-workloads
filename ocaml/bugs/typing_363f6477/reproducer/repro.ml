module M : sig
  type t = private int
  val x : t
end = struct
  type t = int
  let x = 0
end
let rec f () : M.t :> int = (M.x : M.t)
let () = print_int (f ())
