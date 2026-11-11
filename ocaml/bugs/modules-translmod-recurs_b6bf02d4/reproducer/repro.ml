module O (T : sig module N : sig val foo : int -> int end end) = struct
  open T
  let go () = N.foo 42
end
module T = struct module N = struct let foo x = x + 3 end end
module rec M : sig val go : unit -> int end = O (T2)
and T2 : sig include module type of struct include T end end = struct include T end
let () = print_int (M.go ()); print_newline ()
