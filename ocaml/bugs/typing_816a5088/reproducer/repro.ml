type 'a t = private X of 'a
let zeros = object(self) method next = 0, self end
let x = X zeros
