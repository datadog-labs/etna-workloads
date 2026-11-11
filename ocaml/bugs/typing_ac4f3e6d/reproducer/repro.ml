type 'a s
type ('a, 'p) t = private 'a s
type 'a packed = T : ('a, _) t -> 'a packed [@@unboxed]
