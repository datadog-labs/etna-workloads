module Root = struct
  type u
  and t = private < .. >
end
module Trunk = struct
  include Root
  type t = A
  type u
end
module M: sig
  module type s = module type of Trunk
end = struct
  module type s = sig
    type t = A
    type u
  end
end
let () = print_endline "ok"
