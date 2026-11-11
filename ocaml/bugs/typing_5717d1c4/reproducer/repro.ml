module M = struct type 'a p end
type 'a cstr = X of 'a constraint 'a = _ M.p
type x = int M.p cstr
type ab = A of x | B of x
let test = function
   | A a -> [a]
   | B a -> [a]
