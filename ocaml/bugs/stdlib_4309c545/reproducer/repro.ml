let () =
  let a = Array.of_seq (List.to_seq [1;2;3]) in
  if a = [|1;2;3|] then print_endline "ok"
  else (print_endline "wrong"; exit 1)
