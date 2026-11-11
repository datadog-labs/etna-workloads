module MP = Gc.Memprof
let () =
  let n = ref 0 in
  let alloc_minor (i : MP.allocation) = n := !n + i.n_samples; None in
  let _ = MP.start ~sampling_rate:1. {MP.null_tracker with alloc_minor} in
  for _ = 1 to 10 do ignore (Sys.opaque_identity (Array.make 10 'a')) done;
  MP.stop ();
  Printf.printf "%d\n" !n
