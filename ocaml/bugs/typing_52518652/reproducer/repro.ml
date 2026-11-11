module P = struct
  module M = struct type t = A end
  type v = M.t
  module Q = struct
    module M = struct type t = B end
    let f (x : v) = match x with A -> ()
  end
end
