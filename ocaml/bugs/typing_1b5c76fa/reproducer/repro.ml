type t = private [> `A | `B ]
let g : t -> int = function `A -> 1 | `B -> 2
