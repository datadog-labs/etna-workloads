module B = struct
 module R = struct type t = string end
 module O = R
end
module K = struct
 module E = B
 module N = E.O
end
let x : K.N.t = "foo"
