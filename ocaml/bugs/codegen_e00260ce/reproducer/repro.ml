let f : float array = [| |]
let g : float array = Array.make 0 0.0
let () =
  if compare f g = 0 then print_endline "ok"
  else (print_endline "bad"; exit 1)
