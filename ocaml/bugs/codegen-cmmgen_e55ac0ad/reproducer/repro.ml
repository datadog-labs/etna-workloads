exception Foo
let f x = if x > 42 then 1 else raise Foo
let t g = try ignore (g ()); "no" with Foo -> "ok" | Division_by_zero -> "div"
let () =
  let f = Sys.opaque_identity f in
  let z = List.hd (Sys.opaque_identity [0]) in
  print_endline (t (fun () -> (f 0) / z));
  print_endline (t (fun () -> (f 0) mod z))
