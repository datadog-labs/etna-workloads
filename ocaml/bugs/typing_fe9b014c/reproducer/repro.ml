module type S = sig
  module F:  sig val x : int end -> sig end
end
