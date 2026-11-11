type 'a t = ..
module B : sig type 'a t += A : 'b -> 'c t end = struct type 'a t += A : 'a -> 'a t end
