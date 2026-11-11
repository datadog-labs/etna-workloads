module Element : sig
  type +'a t
  val to_a  : unit -> [`A] t
  val to_ab : unit -> [< `A | `B] t
end = struct
  type +'a t
  let to_a x = assert false
  let to_ab x = assert false
end
let f () =
  let open Element in
  let x = if true then to_ab () else to_a () in
  (x :> [ `A | `C ] Element.t)
let () = print_string "ok\n"
