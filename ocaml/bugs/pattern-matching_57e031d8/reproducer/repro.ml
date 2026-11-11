let f = function
  | (`B (x, _, Some y) | `B (x, Some y, _)) when y -> ignore x
  | _ -> ()
