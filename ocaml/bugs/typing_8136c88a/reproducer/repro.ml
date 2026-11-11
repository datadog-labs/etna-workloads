type t = { f : 'a. 'a list } [@@unboxed]
let x = { f = [] }
let a = Array.make 2 x
let () = print_int (Array.length a)
