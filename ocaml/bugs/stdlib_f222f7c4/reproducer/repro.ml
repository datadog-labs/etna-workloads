let () =
  set_binary_mode_in stdin true;
  let r = try In_channel.input_all stdin with _ -> "" in
  let n = 300000 in
  let d = String.init n (fun i -> Char.chr (i * 7 land 255)) in
  if r = d then print_endline "ok" else (print_endline "BUG"; exit 1)
