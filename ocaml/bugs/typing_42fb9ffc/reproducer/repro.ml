module M = struct
  type t = < foo: int; bar: int>
  let x = object method foo = 0 method bar = 0 end
end
module A : sig end = struct
  module F (X : sig type t = private < foo:int; ..> val x : t end) = struct
    let x : < foo: int; ..> = X.x
  end
  module N = F(M)
  let _ = (N.x = M.x)
end
let () = print_endline "ok"
