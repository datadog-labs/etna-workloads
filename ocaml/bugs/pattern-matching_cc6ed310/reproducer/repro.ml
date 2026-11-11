type expr = E of int [@@unboxed]
let f x = match x with (E e) -> e
