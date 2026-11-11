let f ([ bad ] : 'a. 'a list) = print_endline bad
let () = try f [] with Match_failure _ -> print_endline "match failure"
