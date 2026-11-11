let f (a : bool) (b : 'a) = match a, b with
  | ((true as x, _) as p) | ((false as x, _) as p) -> x, p
