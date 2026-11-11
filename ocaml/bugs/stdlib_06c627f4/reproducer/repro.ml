module S = Set.Make(Int)
let () =
  let s = S.of_list [0;1;2;3;4;5;6;7;8;9] in
  let m = S.map (fun x -> x / 3 * 3 - x + 20 - x) s in
  let l = List.sort_uniq compare (List.map (fun x -> x / 3 * 3 - x + 20 - x) (S.elements s)) in
  if S.elements m = l && List.for_all (fun x -> S.mem x m) l then print_endline "ok"
  else (print_endline "BUG"; exit 1)
