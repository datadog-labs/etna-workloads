let () =
  let s = "let f = fun ~l:(l[@foo]) -> ()\nlet g = ((a; b)[@foo]); c" in
  let ast = Parse.implementation (Lexing.from_string s) in
  print_endline (Format.asprintf "%a" Pprintast.structure ast)
