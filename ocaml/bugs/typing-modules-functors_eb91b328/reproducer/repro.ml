module type S = sig type t end
module Res_ko = (functor (X : S) -> X)(struct type t = int end)
let f (x : Res_ko.t) : int = x
