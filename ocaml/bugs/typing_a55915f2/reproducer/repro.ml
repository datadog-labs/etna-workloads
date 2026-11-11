[@@@ocaml.warning "-21-5"]
let foo g () = g 1; ()
let f1 ?x y = print_endline "f1"
let () =
  try foo (raise Exit; f1); print_endline "FAIL"
  with Exit -> print_endline "OK"
