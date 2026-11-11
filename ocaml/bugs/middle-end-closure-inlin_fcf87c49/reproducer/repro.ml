let[@ocaml.inline always] f ?(x = 1.) a b = a +. b *. x
let () =
  let r = ref 0. in
  let x0 = Gc.allocated_bytes () in
  let x1 = Gc.allocated_bytes () in
  for _ = 1 to 1000 do
    r := !r +. f 1. 1.
  done;
  let x2 = Gc.allocated_bytes () in
  if x1 -. x0 = x2 -. x1 then print_endline "no alloc"
  else (print_endline "alloc"; exit 1)
