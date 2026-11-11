let rec gen acc = function 0 -> acc | n -> gen (float n :: acc) (n-1)
let rec long t0 =
  let r = List.length (List.rev_map sin (gen [] 100000)) in
  if Sys.time () -. t0 > 1.5 then Printf.printf "done %d\n%!" r else long t0
let inter () =
  Thread.delay 0.1; print_endline "I1"; Thread.delay 0.1; print_endline "I2"
let () = ignore (Thread.create inter ()); long (Sys.time ())
