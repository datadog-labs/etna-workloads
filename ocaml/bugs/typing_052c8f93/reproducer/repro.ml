type zero = Zero
type 'a succ = Succ of 'a
type _ nat = NZ : zero nat | NS : 'a nat -> 'a succ nat
type (_,_) seq =
  | Snil  : ('a,zero) seq
  | Scons : 'a * ('a,'n) seq -> ('a, 'n succ) seq
type (_,_,_) plus =
  | PlusZ : 'a nat -> (zero, 'a, 'a) plus
  | PlusS : ('a,'b,'c) plus -> ('a succ, 'b, 'c succ) plus
let rec length : type a n. (a,n) seq -> n nat = function
  | Snil -> NZ
  | Scons (_, s) -> NS (length s)
type (_,_,_) app = App : ('a,'p) seq * ('n,'m,'p) plus -> ('a,'n,'m) app
let rec app : type a n m. (a,n) seq -> (a,m) seq -> (a,n,m) app =
  fun xs ys ->
  match xs with
  | Snil -> App (ys, PlusZ (length ys))
  | Scons (x, xs') ->
      let App (xs'', pl) = app xs' ys in
      App (Scons (x, xs''), PlusS pl)
let () = print_endline "ok"
