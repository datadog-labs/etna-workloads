type l = { lbl : int }
module M : sig
  type t = A of { l_c : int }
end = struct
  type t = A of { l_c : int }
end

let _ = M.A { l_c = 42 }
open M
let _ = A { l_c = 42 }
let f (A { l_c }) ({ lbl } as l) = l_c + lbl + l.lbl
