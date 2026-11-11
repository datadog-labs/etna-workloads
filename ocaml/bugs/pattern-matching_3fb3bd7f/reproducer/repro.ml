type import_error = Node of string
type export_error = Variant of string * string
exception Import of import_error
exception Export of export_error
let f = function
  | Import (Node _) -> 1
  | Export (Variant (_, _)) -> 2
  | _ -> 3
let () =
  assert (f (Import (Node "foo")) = 1);
  assert (f (Export (Variant ("foo", "bar"))) = 2);
  print_string "ok\n"
