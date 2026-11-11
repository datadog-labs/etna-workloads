exception Foo
let f x = if x > 42 then 1 else raise Foo
let t g = match g () with exception Foo -> "Foo" | _ -> "other"
let () =
  let f = Sys.opaque_identity f in
  print_endline (t (fun () -> (f 0) / (List.hd (Sys.opaque_identity [0]))));
  print_endline (t (fun () -> (f 0) mod (List.hd (Sys.opaque_identity [0]))))
