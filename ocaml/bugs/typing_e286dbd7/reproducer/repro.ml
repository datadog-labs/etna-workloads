let t =
  (function `A | `B -> () : 'a) (`A : [`A]);
  (failwith "dummy" : 'a)
