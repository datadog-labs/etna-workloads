let access (a: string array) n =
  try ignore (a.(n)); -1 with _ -> n
let () = Printf.printf "%d\n" (access [||] 1)
