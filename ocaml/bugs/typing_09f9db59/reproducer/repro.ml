module type s = sig
  type top
  and t = private < .. >
  and mid
  and u = private < .. >
  and v
end with type t = private < .. >
    with type u = private < .. >
module type s2 = s
module M : s2 = struct
  type top and t = private < .. > and mid and u = private < .. > and v
end
