module S = Set.Make(Int)
let () =
  let s = S.of_list [1;2;3;4;5;6;7;8;9;10] in
  let m = S.map (fun x -> (x * 7) mod 11) s in
  let ok = S.elements m = List.sort compare (List.map (fun x -> (x*7) mod 11) [1;2;3;4;5;6;7;8;9;10])
    && List.for_all (fun i -> S.mem i m) [1;2;3;4;5;6;7;8;9;10] in
  print_endline (if ok then "ok" else "BAD"); exit (if ok then 0 else 1)
