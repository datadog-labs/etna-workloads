module A = struct
  module B = struct
    external id : int -> int = "%identity"
    external id2 : int -> int = "%identity"
    let x = 42
    let y = "hi"
  end
  module C = B
  module D = C
end
module E = A.D
module F = struct module G = A.D end
open F
let () = Printf.printf "%d %s %d\n" E.x E.y (E.id 3)
let () = Printf.printf "%d %s %d\n" G.x G.y (G.id 3)
let () = Printf.printf "%d %s %d\n" A.C.x A.C.y (A.D.id2 3)
module H (X : sig module M : sig external id : int -> int = "%identity" val x : int end end) = struct module Y = X.M let z = Y.x end
module I = H(struct module M = A.B end)
let () = Printf.printf "%d\n" I.z
