let why : unit -> unit = fun () -> raise Exit [@@inline never]
let f () =
  for _i = 1 to 10 do
    why @@ ();
  done;
  ignore (3 + 2);
  () [@@inline never]

let () =
  f ()
