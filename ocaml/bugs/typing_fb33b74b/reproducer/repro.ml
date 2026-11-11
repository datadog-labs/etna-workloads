type _ t = IntLit : int t | BoolLit : bool t
let f (type a) (pair : a t * a) =
  match `Foo pair with
  | `Foo ( IntLit, 3
         | BoolLit, true ) -> ()
  | _ -> ()
