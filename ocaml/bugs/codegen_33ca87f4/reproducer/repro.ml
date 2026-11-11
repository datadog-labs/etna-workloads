let f () = 0 [@@inline never]
let t g = try ignore (g ()); "no exn" with Division_by_zero -> "exn"
let () =
  print_endline (t (fun () -> 0 / f ()));
  print_endline (t (fun () -> 0 mod f ()))
