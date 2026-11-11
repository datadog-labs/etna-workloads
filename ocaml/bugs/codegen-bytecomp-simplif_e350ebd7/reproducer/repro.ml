let () =
  let f () = () in
  let r = ref 0 in
  let g () = f (incr r) in
  g ();
  print_int !r; print_newline ()
