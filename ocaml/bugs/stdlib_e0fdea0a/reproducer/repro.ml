let t s =
  let b = Buffer.create 16 in
  (try Buffer.add_substitute b (fun x -> "<"^x^">") s
   with Not_found -> Buffer.add_string b "NF");
  print_endline (Buffer.contents b)
let () = t "a $ b"; t "$x y"; t "\\$x"; t "$a"; t "${a}b"; t "$"
