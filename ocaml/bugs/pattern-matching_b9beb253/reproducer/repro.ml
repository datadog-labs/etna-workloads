module M : sig type t type u end = struct type t = int type u = bool end
type _ t = Foo : M.t -> M.t t | Bar : M.u -> M.u t
class d = fun (Foo _, Foo _ : M.t t * M.t t) -> object end
