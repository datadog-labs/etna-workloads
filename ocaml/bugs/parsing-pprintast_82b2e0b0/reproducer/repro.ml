let () = match (fun () -> ()) with
  | effect Not_found, k -> ignore k
  | _ -> ()
