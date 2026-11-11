let f x = x mod 1
let g x = x mod (-1)
let () = let n = Array.length Sys.argv + 6 in Printf.printf "%d %d %d\n" (f n) (g n) (f (-n))
