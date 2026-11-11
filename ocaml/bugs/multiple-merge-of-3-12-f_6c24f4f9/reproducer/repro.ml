let () =
  let r = try Scanf.sscanf "abc%d" "%s@%%d" (fun s -> s) with _ -> "EXN" in
  print_endline r
