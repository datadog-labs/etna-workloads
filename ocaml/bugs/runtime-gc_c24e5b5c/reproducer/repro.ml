type m3 = { mutable s: int; mutable t:int; mutable u:int }
let () =
  let before = Gc.minor_words () in
  let n = 1_000_000 in
  for i = 1 to n do
    ignore (Sys.opaque_identity { s = i; t = i; u = i })
  done;
  let after = Gc.minor_words () in
  Printf.printf "%d\n" (int_of_float (after -. before) - 4*n)
