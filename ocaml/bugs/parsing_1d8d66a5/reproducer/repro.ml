let why () = raise Exit [@@inline never]
let f () =
  for _i = 1 to 2 do
    why ();
  done [@@inline never]
let () = f ()
