type (_, _) eq = Eq : ('a, 'a) eq
let bad : type a. ?opt:(a, int -> int) eq -> unit -> a =
  fun ?opt:((Eq : (a, int -> int) eq) = assert false) () x -> x + 1
