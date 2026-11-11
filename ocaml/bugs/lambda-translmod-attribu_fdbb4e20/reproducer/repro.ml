module TestInlineStruct = struct
  module I = Set.Make [@inlined]
  module J = Set.Make [@@inlined]
end
