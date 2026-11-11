module T : sig val f : < m : int > -> int end = struct
  module M = struct class c = object method m = 1 end end
  open M
  let f (o : #c) = o#m
end
