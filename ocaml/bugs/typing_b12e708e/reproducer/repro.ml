module Test1 = struct
  type t = private int
  let f x = let y = if true then x else (x:t) in (y :> int)
end
