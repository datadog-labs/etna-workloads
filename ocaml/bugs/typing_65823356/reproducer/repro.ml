type _ t = K : ([< `A | `B ] as 'a) -> 'a t
let f : type a. a t -> a = function K _ -> `A
