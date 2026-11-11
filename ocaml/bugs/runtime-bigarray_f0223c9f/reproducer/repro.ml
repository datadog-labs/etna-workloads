let () =
  let a = Bigarray.(Array1.create float16 c_layout 10) in
  Bigarray.Array1.fill a 1.5;
  match Marshal.from_string (Marshal.to_string a []) 0 with
  | b -> print_endline (if b = a then "ok" else "differ")
  | exception Failure m -> print_endline ("failure: " ^ m); exit 1
