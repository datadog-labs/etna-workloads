let () =
  try Arg.parse_argv ~current:(ref 0) [|"t";"-unit=1"|] ["-unit",Arg.Unit ignore,""] ignore "U"
  with Arg.Bad s -> print_string s
