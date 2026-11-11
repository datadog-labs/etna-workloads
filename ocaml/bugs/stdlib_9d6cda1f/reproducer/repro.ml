let () =
  let a = Float.Array.init 5 float_of_int in
  Float.Array.blit a 0 a 1 4;
  Float.Array.iter (Printf.printf "%g ") a;
  print_newline ()
