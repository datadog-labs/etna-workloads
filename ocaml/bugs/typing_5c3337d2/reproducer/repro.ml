module type x = sig type x end
module type y = sig type y end
module F(X:x)(Y:y) = struct end
module M = F(struct end)(struct end)
