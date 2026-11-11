let () =
  Gc.minor ();
  let r = List.init 1000 Sys.opaque_identity in
  Gc.minor ();
  let _ = Sys.opaque_identity (List.init 1000 (fun _ -> "!")) in
  List.iteri (fun i j -> assert (i = j)) r;
  print_endline "done"
;;
