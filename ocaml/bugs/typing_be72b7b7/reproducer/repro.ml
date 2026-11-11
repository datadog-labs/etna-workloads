module rec TypedGui : sig
  class type untyped = object end
  class type t = object inherit untyped end
end = TypedGui
let () = print_endline "ok"
