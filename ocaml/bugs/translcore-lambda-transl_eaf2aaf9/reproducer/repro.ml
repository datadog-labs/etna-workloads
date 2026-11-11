let f ?(y = assert false) (lazy e) = () in
  try f (lazy (print_endline "hello")) with _ -> print_endline "failed";;
