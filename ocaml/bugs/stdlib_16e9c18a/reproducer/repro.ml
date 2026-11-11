exception My_exception
let () =
  Printexc.set_uncaught_exception_handler (fun exn _ ->
    match exn with
    | My_exception -> print_endline "Caught"; exit 0
    | _ -> print_endline "Unexpected");
  at_exit (fun () -> print_endline "Last");
  at_exit (fun () -> print_endline "Raise"; raise My_exception);
  at_exit (fun () -> print_endline "First")
