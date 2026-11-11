let n = 4
let ready = ref 0
let yields = ref 0
let last = ref (-1)
let maxrun = ref 0
let rep r = if r > !maxrun then maxrun := r
let ths = List.init n (Thread.create (fun i ->
  incr ready;
  while !ready < n do Thread.yield () done;
  let c = ref 0 in
  while !yields < 50000 do
    incr yields; last := i; Thread.yield (); incr c;
    if !last <> i then (rep !c; c := 0)
  done;
  if !c > 0 then rep !c))
let () = List.iter Thread.join ths;
  if !maxrun > 50 then (print_endline "unfair yield"; exit 1)
  else print_endline "fair yield"
