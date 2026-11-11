type empty = Empty and filled = Filled
type ('a,'fout,'fin) opt =
  | N : ('a, 'f, 'f) opt
  | Y : 'a -> ('a, filled, empty) opt
type 'fill either =
  | Either : (string, 'fill, 'f) opt * (int, 'f, empty) opt -> 'fill either
let f = fun (Either (Y a, N)) -> a
