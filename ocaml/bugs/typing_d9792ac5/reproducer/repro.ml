module rec X : sig
  type 'a t = 'a X.s as 'b
    constraint 'b = int
  type 'a s = int
end = X
