type 'a t = T of ('a * 'a) t [@@unboxed]
external f : (int t [@unboxed]) -> unit = "f" "f_nat"
