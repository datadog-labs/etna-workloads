let () =
  let lb = Lexing.from_string "let _ = a #+ b" in
  let s = Parse.implementation lb in
  let str = Format.asprintf "%a" Pprintast.structure s in
  match Parse.implementation (Lexing.from_string str) with
  | _ -> print_endline "ok"
  | exception _ -> print_endline "reparse failed"
