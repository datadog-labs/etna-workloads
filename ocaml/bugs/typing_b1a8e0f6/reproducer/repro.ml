module LamT = struct
  type 'a exp = [`Var of string | `Abs of string * 'e | `App of 'e * 'e]
  constraint 'a = <exp:'e;..>
end
module type LamS = sig
  type exp0 = private [> a LamT.exp]
  and a = <exp:exp0>
end
let () = print_endline "ok"
