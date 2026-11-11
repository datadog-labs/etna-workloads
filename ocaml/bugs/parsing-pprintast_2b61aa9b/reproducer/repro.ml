let () =
  let ast = Parse.implementation (Lexing.from_string "let f = function (module M : (A [@a])) -> ()") in
  Format.printf "%a@." Pprintast.structure ast
