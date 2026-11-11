let poly_poly_var : [< `A | `B ] -> unit = function `A | `B -> ()
let accept (f : 'a. ([< `A | `B ] as 'a) -> unit) = f `A
let () = accept poly_poly_var; print_endline "ok"
