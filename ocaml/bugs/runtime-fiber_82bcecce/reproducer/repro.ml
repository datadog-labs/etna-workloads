open Effect
open Effect.Deep
type _ Effect.t += E : int Effect.t
let mk () : (int,int) continuation = Obj.magic @@ match_with (fun () -> perform E) () 
  { retc = (fun x -> x); exnc = raise;
    effc = (fun (type a) (e : a Effect.t) -> match e with
      | E -> Some (fun (k : (a,_) continuation) -> Obj.magic k) | _ -> None) }
let () =
  let s = ref 0 in
  for _ = 1 to 200 do
    let d = Domain.spawn (fun () -> List.init 20 (fun _ -> mk ())) in
    let ks = Domain.join d in
    List.iter (fun k -> s := !s + continue k 1) ks
  done;
  Printf.printf "%d\n" !s
