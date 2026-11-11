module rec Id : sig
  type t = {id : int}
  val compare : t -> t -> int
end = Id
module IdSet = Set.Make(Id)
let () = try
  let s = IdSet.singleton {Id.id = 0} in
  ignore (IdSet.mem {Id.id = 1} s); print_endline "no exception"
with e -> print_endline (Printexc.to_string e)
