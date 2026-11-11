let () =
  let r = Str.regexp (String.concat "" (List.init 40 (fun _ -> "\\(a\\)"))) in
  let s = String.make 40 'a' in
  ignore (Str.string_match r s 0);
  try print_endline (Str.matched_group 38 s) with _ -> print_endline "fail"; exit 1
