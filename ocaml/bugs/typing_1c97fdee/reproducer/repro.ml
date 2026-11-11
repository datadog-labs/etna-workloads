let f (n : < m : 'a. [< `Foo of 'a & int | `Bar] >) =
  (n : < m : 'b. [< `Foo of 'b & int | `Bar] >)
let () = print_string "ok\n"
