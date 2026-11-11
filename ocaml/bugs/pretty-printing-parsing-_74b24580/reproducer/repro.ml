let () =
  let ty = Ast_helper.Typ.var "a'b" in
  let s = Format.asprintf "%a" Pprintast.core_type ty in
  print_endline s;
  match Parse.core_type (Lexing.from_string s) with
  | t when t.Parsetree.ptyp_desc = ty.Parsetree.ptyp_desc -> ()
  | _ -> print_endline "different"; exit 1
  | exception _ -> print_endline "reparse failed"; exit 1
