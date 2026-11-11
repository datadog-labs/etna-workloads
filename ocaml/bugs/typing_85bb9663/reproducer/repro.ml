module B : sig
 type (_, _) t = Eq: ('a, 'a) t
 val f: 'a -> 'b -> ('a, 'b) t
end = struct
 type (_, _) t = Eq: ('a, 'a) t
 let f _ _ = Obj.magic Eq
end
let of_type: type a. a -> a = fun x ->
  match B.f x 4 with
  | Eq -> 5
let () = print_int (of_type 1)
