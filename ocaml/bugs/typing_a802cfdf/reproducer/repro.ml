let flag = ref false
module F(S : sig module type T end) (A : S.T) (B : S.T) =
struct
  module X = (val if !flag then (module A) else (module B) : S.T)
end
