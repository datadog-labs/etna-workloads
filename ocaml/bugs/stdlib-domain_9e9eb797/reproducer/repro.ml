let () =
  let ok = ref true in
  for _ = 1 to 3 do
    let d = Domain.spawn (fun () -> (Domain.self () :> int)) in
    let g = (Domain.get_id d :> int) in
    if g <> Domain.join d then ok := false
  done;
  print_endline (if !ok then "ok" else "bad")
