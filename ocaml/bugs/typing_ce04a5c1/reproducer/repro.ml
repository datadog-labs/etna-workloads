class setup = object
  method with_ f = (f 0:unit)
end
class virtual fail = object (self)
  method trigger = (self :> setup )
end
let () = print_endline "ok"
