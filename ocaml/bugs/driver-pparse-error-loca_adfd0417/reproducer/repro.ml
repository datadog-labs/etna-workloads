let () =
  let ast = Pparse.parse_implementation ~tool_name:"test" "foo.ml" in
  Pparse.write_ast Pparse.Structure "foo.marshalled.ml" ast
