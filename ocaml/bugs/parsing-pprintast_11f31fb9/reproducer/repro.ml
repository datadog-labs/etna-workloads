let () =
  let s = "let f : int -> int = fun x -> x\nlet g : 'a. 'a -> 'a = fun x -> x\n" in
  let ast = Parse.implementation (Lexing.from_string s) in
  let out = Format.asprintf "%a" Pprintast.structure ast in
  match Parse.implementation (Lexing.from_string out) with
  | exception _ -> print_endline "reparse failed"; exit 1
  | a2 ->
    let open Ast_mapper in
    let m = { default_mapper with location = (fun _ _ -> Location.none) } in
    if m.structure m ast = m.structure m a2 then print_endline "same"
    else (print_endline "different"; exit 1)
