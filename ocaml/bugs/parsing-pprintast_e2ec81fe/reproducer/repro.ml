let () =
  let lb = Lexing.from_string "type t = [ | a ]" in
  let s = Parse.implementation lb in
  Format.printf "%a@." Pprintast.structure s
