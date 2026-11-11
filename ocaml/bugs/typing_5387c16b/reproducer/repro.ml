module M = struct let f () = 1 end
let f () = M.(f ())
