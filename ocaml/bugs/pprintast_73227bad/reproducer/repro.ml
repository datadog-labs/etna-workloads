let () =
  let s = "let _ = 1 :: ([] [@a])" in
  let ast = Parse.implementation (Lexing.from_string s) in
  Format.printf "%a@." Pprintast.structure ast
