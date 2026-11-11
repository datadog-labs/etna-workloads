let d = ref (-1)
let () =
  let a = Sys.opaque_identity min_int in
  Printf.printf "%d %d\n" (a / !d) (a mod !d);
  let b = Sys.opaque_identity Int64.min_int and e = Sys.opaque_identity (-1L) in
  Printf.printf "%Ld %Ld\n" (Int64.div b e) (Int64.rem b e)
