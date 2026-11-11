type _ t = Int : int -> int t | True : bool t | False : bool t
let r = ref False
let f : unit lazy_t * bool t ref -> int = function
  | (_, { contents = True }) -> 0
  | (lazy (), { contents = False }) -> 12
let () =
  let l = lazy (r := Obj.magic (Int 3)) in
  match f (l, r) with
  | n -> print_int n; print_newline (); exit 1
  | exception Match_failure _ -> print_endline "match failure"
