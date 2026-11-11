type i = <m : 'c. 'c -> 'c >
type ('a, 'b) j = <m : 'c. 'a -> 'b >
type _ t = A : i t
let f (type a b) (y : (a, b) j t) : a -> b =
  let A = y in fun x -> x
