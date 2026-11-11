module M = struct
  [@@@warning "-32"]
  let f x = x
  let[@warning "+32"] g x = x
end
