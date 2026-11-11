module type S = sig
  type t [@@immediate]
end

type m1 = (module S with type t = int)
let () = print_endline "ok"
