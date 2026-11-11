let () =
  let s = "let f : 'a. 'a -> 'a = (fun x -> x) [@foo]" in
  let ast = Parse.implementation (Lexing.from_string s) in
  Format.printf "%a@." Pprintast.structure ast
