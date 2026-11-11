let c = ref []
let () =
  for _ = 0 to 25000 do
    c := 0 :: !c;
    Gc.compact ()
  done;
  print_endline "done"
