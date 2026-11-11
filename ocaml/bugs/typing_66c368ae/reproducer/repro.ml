let f (type a) (x : a) =
  let ref : type a . a option ref = ref None in
  ref := Some x;
  Option.get !ref
