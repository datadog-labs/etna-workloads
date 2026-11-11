module type S = sig val x : int end
let f p = match p with
  | (module M : S) when M.x > 0 -> 1
  | _ -> 0
let () = print_int (f (module struct let x = 3 end : S))
