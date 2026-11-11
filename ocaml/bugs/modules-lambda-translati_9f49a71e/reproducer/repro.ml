type re = { mutable cell : string }
let s = { cell = "" }
module _ = struct
  let () = s.cell <- "Hello World!"
end
let drop _ = ()
let () = drop s.cell
let () = print_endline s.cell
