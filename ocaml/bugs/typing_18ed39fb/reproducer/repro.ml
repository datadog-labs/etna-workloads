module type S = sig
  class type c = object method m : int end
  module M : sig
    class type d = c
  end
end
module F (X : S) = X.M
