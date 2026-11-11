module M = struct type t let equal = (=) end
type t = Set.Make(M).t
