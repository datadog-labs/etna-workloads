module type S = functor (X : sig type 'a t = 'a * 'a end) (Y : sig type 'a t = 'a X.t * 'a list end) -> sig end
module F : S = functor (X : sig type 'a t = 'a list end) (Y : sig type 'a t = 'a X.t * 'a list end) -> struct end
