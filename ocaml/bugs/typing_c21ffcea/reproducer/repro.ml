module M : sig type 'a t = 'a constraint 'a = [< `A | `A of int | `B] end =
  struct type 'a t = 'a constraint 'a = [< `A | `A of int | `B] end
let () = print_string "ok\n"
