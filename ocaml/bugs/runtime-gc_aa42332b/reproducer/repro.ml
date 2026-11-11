let tree_size = 9
let rec make d = if d = 0 then [||] |> fun _ -> Some (ref 0) |> fun _ -> Obj.repr 0 else Obj.repr (make (d-1), make (d-1))
let fc = Atomic.make 0
let wc = Atomic.make 0
let work () =
  for _ = 0 to 250 do
    let v = make tree_size in
    Gc.finalise (fun _ -> Atomic.incr fc) v;
    Atomic.incr wc
  done
let () =
  for _ = 0 to 10 do
    let ds = Array.init 3 (fun _ -> Domain.spawn work) in
    ignore (make tree_size);
    Array.iter Domain.join ds
  done;
  Gc.full_major ();
  assert (Atomic.get fc = Atomic.get wc);
  print_string "ok\n"
