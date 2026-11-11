type ('a, 'b) almost_eq = Almost_refl : 'c -> ('c, 'c) almost_eq [@@unboxed]
type valid1 = Any : ('a, int) almost_eq -> valid1 [@@unboxed]
