module type S = sig module M : sig end module N = M end
module rec M : S with module M := M = M
