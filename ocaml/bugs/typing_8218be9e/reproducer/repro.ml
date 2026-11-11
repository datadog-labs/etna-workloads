module A = struct
  type a and b and c and d
end
module type S = sig
  module B = A
end
module C : S = struct
  module B = struct
    type a and b and c and d and e and f and g and h
  end
end
