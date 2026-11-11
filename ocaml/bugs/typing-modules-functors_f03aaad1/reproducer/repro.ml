module M = struct type t end
module Generative() = struct type t end
type t = Generative(M).t
