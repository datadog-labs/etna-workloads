type t = C0 | C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | C10 | C11 | C12 | C13 | C14 | C15 | C16 | C17 | C18 | C19 | C20 | C21 | C22 | C23 | C24 | C25 | C26 | C27 | C28 | C29 | C30 | C31 | N0 of int
let f x y = match x, y with
  | N0 _, C3 when Sys.argv = [||] -> 1
let () = print_endline (try string_of_int (f (N0 1) C3) with Match_failure _ -> "0")
