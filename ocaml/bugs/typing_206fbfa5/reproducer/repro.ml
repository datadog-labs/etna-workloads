module C = struct
  class c = object end
end
module R = struct
  include C
  type c
end
let () = print_endline "ok"
