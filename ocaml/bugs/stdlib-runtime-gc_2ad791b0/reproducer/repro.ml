type t = Leaf of int | Branch of t * t
type floatref = { mutable f : float }
let a = { f = 0.0 }
let rec allocate_lots m = function
  | 0 -> Leaf m
  | n -> Branch (allocate_lots m (n-1), allocate_lots (m+1) (n-1))
let measure f =
  let a = Gc.minor_words () in
  f ();
  let c = Gc.minor_words () in
  c -. a
let () =
  let n = measure (fun () -> a.f <- Gc.minor_words ()) in
  let m = measure (fun () -> ignore (Sys.opaque_identity (allocate_lots 42 10))) in
  if n = 0. && m > 3000. then print_endline "ok"
  else (print_endline "bad"; exit 1)
