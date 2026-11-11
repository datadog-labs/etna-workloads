type ('a,'b) pair = {right:'a; left:'b}
type a = A of int | B of bool
type t = TA | TB
let f = function
  | {left=TA; right=A z} -> z
  | {left=TB; right=A z} -> z
  | {left=TA; right=B _} -> 0
