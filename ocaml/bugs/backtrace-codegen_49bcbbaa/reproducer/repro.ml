open Effect
open Effect.Deep
type _ t += E : unit t
let bar () =
    perform E;
    20
let foo () =
  ignore @@ bar ();
  0
let _ =
  match_with foo ()
  { retc = (fun _ -> ());
    exnc = (fun e -> raise e);
    effc = fun (type a) (e : a t) ->
      match e with
      | E -> Some (fun (k : (a, _) continuation) ->
          let bt = Deep.get_callstack k 100 in
          print_string @@ Printexc.raw_backtrace_to_string bt;
          continue k ())
      | _ -> None }
