class c = let x = new c in object method m = (x : c) end
let () = ignore (new c); print_endline "constructed"
