module M = struct type t = int exception E of t end
exception F = M.E
let () = try raise (F 3) with M.E n -> print_int n
exception G = Not_found
let () = try raise Not_found with G -> print_string " ok"
let () = print_newline ()
