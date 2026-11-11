let r =
  let module A:sig
    type f
    type x
    val succ: f
    val zero:x
    external (@@): f -> x -> int = "%apply"
  end = struct
    type f = int -> int
    type x = int
    let succ = succ
    let zero = 0
    external (@@): f -> x -> int = "%apply"
  end in
  A.(succ @@ zero)
let () = print_int r; print_newline ()
