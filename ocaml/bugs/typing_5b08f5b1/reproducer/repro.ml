type _ int_foo = IF_constr : <foo:int; ..> int_foo
type _ int_bar = IB_constr : <bar:int; ..> int_bar
let g (type t) (x:t) (e : t int_foo) (e' : t int_bar) =
  let IF_constr, IB_constr = e, e' in
  (x:<foo:int;bar:int>)
