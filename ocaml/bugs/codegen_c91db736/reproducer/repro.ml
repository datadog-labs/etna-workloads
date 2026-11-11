open Bigarray
let n = ref 0
let f y = incr n; y
let () =
  let y = Array1.of_array float64 fortran_layout [| 1. |] in
  ignore ((f y).{1});
  (f y).{1} <- 3.14;
  Printf.printf "%d\n" !n
