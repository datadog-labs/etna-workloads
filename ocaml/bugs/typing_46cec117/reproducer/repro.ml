module rec A : sig
  type 'a t = T of 'a
  type _ u = U : 'a -> 'a B.t u
end = A
and B : sig type 'a t = 'a A.t end = B
let () = print_string "ok\n"
