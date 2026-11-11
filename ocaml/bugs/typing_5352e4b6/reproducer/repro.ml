module type T = sig
  type t
  val x : t
  val show : t -> string
end
module Int = struct type t = int let x = 0 let show x = Int.to_string x end
module String = struct type t = string let x = "Hello" let show x = x end
let switch = ref true
module Choose () = struct
  module Choice =
    (val if !switch then (module Int : T)
    else (module String : T))
  let r = ref (ref [])
end
module type S = sig
  module Choice : T
  val r : Choice.t list ref ref
end
module Force (X : functor () -> S) = struct end
module M = Choose ()
let () = switch := false
module N = Choose ()
let () = N.r := !M.r
module Ignore = Force(Choose)
