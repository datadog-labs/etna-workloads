class type ['a, 'b] a = object
  method b: ('a, 'b) #b as 'b
  method as_a: ('a, 'b) a
end and ['a, 'b] b = object
  method a: ('a, 'b) #a as 'a
  method as_b: ('a, 'b) b
end;;
class type ['b] ca = object ('s) inherit ['s, 'b] a end;;
class type ['a] cb = object ('s) inherit ['a, 's] b end;;
type bt = 'b ca cb as 'b
;;
