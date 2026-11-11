let () =
  let r = Str.regexp "\\(\\(a\\)b\\)+" in
  List.iter (fun s ->
    let m = Str.string_partial_match r s 0 in
    Printf.printf "%S %b" s m;
    for i = 0 to 2 do
      Printf.printf " %s" (try Str.matched_group i s with Not_found -> "NF" | Invalid_argument _ -> "INV")
    done; print_newline ()) ["a";"aba";"abab";"ababa"]
