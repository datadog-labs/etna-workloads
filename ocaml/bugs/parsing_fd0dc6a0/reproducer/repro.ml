let rec f : unit -> < m : 'a. 'a -> 'a > = fun () ->
  let x = f () in
  ignore (x#m 1);
  ignore (x#m "hello");
  assert false
