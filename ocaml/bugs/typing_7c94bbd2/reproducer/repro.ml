module type MapT = sig
  type key
  type data
  type map
  val empty : map
end
module SSMap = struct
  include Map.Make(String)
  type data = string
  type map = data t
end
type ('k,'d,'m) map = (module MapT with type key = 'k and type data = 'd and type map = 'm)
let ssmap : (_,_,_) map = (module SSMap)
