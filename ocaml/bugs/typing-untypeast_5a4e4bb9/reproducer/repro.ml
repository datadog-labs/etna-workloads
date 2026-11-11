let () =
  let pe = Parse.expression (Lexing.from_string "let foo : 'a. 'a -> 'a = fun x -> x in foo") in
  let te = Typecore.type_expression Env.initial pe in
  let ute = Untypeast.untype_expression te in
  Format.printf "%a@." Pprintast.expression ute
