let () =
  let p = Parse.pattern (Lexing.from_string "(::) _") in
  Format.printf "%a@." Pprintast.pattern p
