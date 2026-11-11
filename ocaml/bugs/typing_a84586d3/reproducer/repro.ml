type 'a id = 'a
type 'a t constraint 'a = 'b * 'c
type cycle = cycle id
and s = cycle t
