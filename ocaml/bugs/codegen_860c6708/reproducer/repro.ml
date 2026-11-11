let f d = 1 mod d
let g d = (-1) mod d
let () =
  let d = Sys.opaque_identity 1 in
  Printf.printf "%d %d\n" (f d) (g d);
  let z = Sys.opaque_identity 0 in
  print_endline (try string_of_int (f z) with Division_by_zero -> "dz")
