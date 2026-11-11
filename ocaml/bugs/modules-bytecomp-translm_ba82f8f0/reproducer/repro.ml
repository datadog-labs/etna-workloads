module rec M
    : sig external f : int -> int = "%identity" end
    = struct external f : int -> int = "%identity" end
let () = print_int (M.f 3)
