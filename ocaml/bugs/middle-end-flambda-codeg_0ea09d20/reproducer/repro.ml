let t f n = try ignore ((Sys.opaque_identity f) n); "no" with Division_by_zero -> "ok"
let () =
  print_endline (t (fun n -> Int32.div n (Sys.opaque_identity 0l)) 3l);
  print_endline (t (fun n -> Int64.rem n (Sys.opaque_identity 0L)) 3L);
  print_endline (t (fun n -> Nativeint.div n 0n) 3n)
