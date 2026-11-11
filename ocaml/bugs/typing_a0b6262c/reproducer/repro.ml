type (_, _) comp = Eq : ('a, 'a) comp | Diff : ('a, 'b) comp
module U = struct type t = T end
module M : sig
  type t = T
  val comp : (U.t, t) comp
end = struct
  include U
  let comp = Eq
end
let () = try ignore (match M.comp with Diff -> false); print_endline "no failure"
  with Match_failure _ -> print_endline "match failure"
