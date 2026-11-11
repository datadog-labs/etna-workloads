let () =
  match Array.sub [|1;2;3|] (-1) 2 with
  | _ -> print_endline "no exception"
  | exception Invalid_argument _ -> print_endline "ok"
