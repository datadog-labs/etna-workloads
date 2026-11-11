module Seq : sig
  type 'a t = unit -> 'a node
  and 'a node
  val empty : 'a t
  val cons : 'a -> 'a t -> 'a t
end = struct
  type 'a t = unit -> 'a node
  and 'a node = unit
  let empty () = ()
  let cons x xs () = ()
end
let strange x = Seq.[cons x empty; cons empty x]
