let () =
  let e = Parse.expression (Lexing.from_string "r.x <- (a; b)") in
  Format.printf "%a@." Pprintast.expression e
