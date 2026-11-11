type 'par t = 'par
module M : sig val x : <m : 'a. 'a> end =
  struct let x : <m : 'a. 'a t> = Obj.magic () end
let () = print_endline "ok"
