let () =
  try Dynlink.loadfile "plug.cmo"; print_endline "loaded"
  with Dynlink.Error e ->
    let m = Dynlink.error_message e in
    let l = String.length m and k = "no implementation available for Foo" in
    let n = String.length k in
    let rec has i = i + n <= l && (String.sub m i n = k || has (i+1)) in
    print_endline (if has 0 then "no implementation available for Foo" else "other error")
