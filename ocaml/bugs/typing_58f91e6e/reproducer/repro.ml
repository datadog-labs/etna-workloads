module M : sig
  type t = A of (< m : 'a > as 'a)
  type r = { f : (< m : 'a > as 'a) }
end = struct
  type t = A of int
  type r = { f : int }
end
