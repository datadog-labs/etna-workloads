let n = 4
let go = Atomic.make 0
let work () =
  Atomic.incr go;
  while Atomic.get go < n do () done;
  try ignore (Hashtbl.create ~random:true 3); true
  with _ -> false
let () =
  let ds = List.init n (fun _ -> Domain.spawn work) in
  let ok = List.for_all Fun.id (List.map Domain.join ds) in
  print_string (if ok then "ok\n" else "failed\n");
  exit (if ok then 0 else 1)
