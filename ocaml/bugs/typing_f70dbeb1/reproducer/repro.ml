type (_,_) eq = Refl : ('a,'a) eq
let f (type a) (e : (a,int) eq) (x : a) =
  let r = ref [] in
  match e with Refl -> r := [x; 1]; (List.hd !r : a)
