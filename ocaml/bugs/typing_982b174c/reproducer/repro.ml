let revapply x f = f x
let f x (g : [< `Foo]) =
  let y = `Bar x, g in
  revapply y (fun ((`Bar i), _) -> i)
let _ = (f : int -> [< `Foo] -> int)
let h : 'a -> [< `Foo ] -> 'a = f
