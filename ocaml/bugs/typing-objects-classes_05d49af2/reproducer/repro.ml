class virtual b = object
  method private test = ()
end
class c = object
  inherit b
  method test = ()
end
let () = (new c)#test; print_string "ok\n"
