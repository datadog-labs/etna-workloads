let () =
  let a = Float.Array.concat [] in
  let b = Float.Array.concat [Float.Array.create 0] in
  let d = Float.Array.sub (Float.Array.create 1) 1 0 in
  let e = Float.Array.create 0 in
  Printf.printf "%b %b %b\n" (a = e) (b = e) (d = e)
