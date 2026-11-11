let id = let module M = struct end in fun x -> x
let () = ignore (id 1); ignore (id "a")
