module P6235 = struct
  type t = { loc : string; }
  type v = { loc : string; x : int; }
  type u = [ `Key of t ]
  let f (u : u) = match u with `Key {loc} -> loc
end
