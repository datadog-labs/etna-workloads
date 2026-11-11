let float_array : float array = [| |]
let r : float array = Array.make 0 0.0
let () =
  if compare float_array r = 0 && Obj.tag (Obj.repr float_array) = Obj.tag (Obj.repr r)
  then print_endline "ok" else (print_endline "mismatch"; exit 1)
