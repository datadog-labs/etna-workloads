module M: sig
  type t
  module F(X:sig val f:t val g:int end): sig end
end = struct
  type t
  module F(X:sig val f:t val g:float end)= struct end
end
