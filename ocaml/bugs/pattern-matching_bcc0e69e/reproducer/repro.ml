let[@warning "-partial-match"][@warning "-redundant-case"] f x y = match x, y with
  | _, true -> 0
  | (0 | 2), _ -> 1
  | 3, true -> 2
  | -1, _ -> 3
let () =
  match f 4 false with
  | (n : int) -> print_string "ok\n"
  | exception Match_failure _ -> print_string "ok\n"
