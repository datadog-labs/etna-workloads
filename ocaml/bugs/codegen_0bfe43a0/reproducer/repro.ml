let test x =
  let tupled (x, y) = (); fun () -> [|x; y|] in
  match x with
  | None -> [| |]
  | Some (x, y) -> tupled (x, y) ()
let () =
  let r = (test (Some ("Hello ", "World!"))).(0) in
  print_string r; print_newline ()
