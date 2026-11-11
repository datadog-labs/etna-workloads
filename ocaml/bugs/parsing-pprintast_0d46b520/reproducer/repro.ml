let () =
  let lb = Lexing.from_string "type t += A = M.A [@a]\nexception E = Not_found [@a]" in
  let s = Parse.implementation lb in
  let str = Format.asprintf "%a" Pprintast.structure s in
  match Parse.implementation (Lexing.from_string str) with
  | _ -> print_endline "ok"
  | exception _ -> print_endline "reparse failed"; exit 1
