let () =
  let ast = Parse.implementation (Lexing.from_string "let f = function A (type a) (x : a) -> x") in
  Format.printf "%a@." Pprintast.structure ast
