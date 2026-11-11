module type Alias = sig module N : sig end module M = N end
module F (X : sig end) = struct type t end
module type A = Alias with module N := F(List)
