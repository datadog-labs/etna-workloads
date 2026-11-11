module type S = sig type 'a t end
module type T = S with type 'a t = int
module F (M : T) = struct
  type u = U : 'a M.t -> u [@@unboxed]
end
