let () =
  let r = try Scanf.sscanf "ab{cd" "%s@{" (fun s -> s) with _ -> "EXN" in
  let r2 = try Scanf.sscanf "ab[cd" "%s@[" (fun s -> s) with _ -> "EXN" in
  Printf.printf "%s %s\n" r r2;
  if r <> "ab" || r2 <> "ab" then exit 1
