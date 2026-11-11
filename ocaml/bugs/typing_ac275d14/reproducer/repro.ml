type (_,_) seq =
  | Snil  : ('a,int) seq
  | Scons : 'a * ('a,'n) seq -> ('a, 'n option) seq;;
type (_,_,_) plus =
  | PlusZ : 'a list -> (int, 'a, 'a) plus
  | PlusS : ('a,'b,'c) plus -> ('a option, 'b, 'c option) plus;;
