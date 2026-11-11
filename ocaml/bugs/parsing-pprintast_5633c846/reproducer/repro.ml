let () =
  let s = "module type S = (functor (M : S) -> S) -> S" in
  let pp x = Format.asprintf "%a" Pprintast.structure x in
  print_string (pp (Parse.implementation (Lexing.from_string s)))
