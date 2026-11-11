let o3 =
  object (self : 's)
    method private x = 3
    method m : 's -> int = fun other ->
      let module M = struct let other = other end in (M.other#x : int)
  end
let () = print_endline (string_of_int (o3#m o3))
