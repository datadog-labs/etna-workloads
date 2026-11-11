let table = Array.init 10_000 (fun _ -> Bytes.make 1_000 'a')
let major_cycles () = (Gc.quick_stat ()).major_collections
let[@inline never] f ~writes =
  List.init (Array.length table) (fun i ->
    let buf = table.(i) in
    if Sys.opaque_identity writes then table.(i) <- buf;
    Bytes.get buf 42)
let count_cycles ~f =
  Gc.major ();
  let before = major_cycles () in
  for _ = 1 to 10_000 do ignore (Sys.opaque_identity (f ())) done;
  major_cycles () - before
let () =
  let c = major_cycles () in
  while major_cycles () < c + 4 do ignore (Sys.opaque_identity (f ~writes:false)) done;
  let wf = count_cycles ~f:(fun () -> f ~writes:false) in
  let wt = count_cycles ~f:(fun () -> f ~writes:true) in
  if abs (wt - wf) > 2 then (print_endline "error: writes changed cycles"; exit 1)
  else print_endline "ok"
