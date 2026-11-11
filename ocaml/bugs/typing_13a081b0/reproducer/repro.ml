type 'a s = S
type 'a c = < x : 'a list >
let o : 'a c = object
  method x : 'b . 'b s list = [S]
end
