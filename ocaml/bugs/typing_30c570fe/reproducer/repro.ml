module M : sig
  type 'a t = private string
end = struct
  type 'a t = string
end
module Coerce : sig
  type +'a pos = private string
end = struct
  type 'a pos = 'a M.t
end
