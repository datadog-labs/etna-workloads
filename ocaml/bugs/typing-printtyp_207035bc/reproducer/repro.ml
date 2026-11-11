type t;;
type f = [ `A of t ];;
type t = X of u | Y of [ f | `B ]  and u = Y of t;;
