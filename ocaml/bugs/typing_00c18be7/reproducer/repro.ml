type 'a r = [< `X of int & 'a ] as 'a
let f: 'a. 'a r -> 'a r = fun x -> true
