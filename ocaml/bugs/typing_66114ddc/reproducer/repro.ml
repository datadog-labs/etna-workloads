type _ ty = Int : int ty
type dyn = Dyn : 'a ty * 'a -> dyn
let ko1 = function Dyn (type a) (w, x : _) -> ()
