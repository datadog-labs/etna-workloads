let () = Printf.printf "%d %d\n" (compare (List.compare_length_with [] min_int) 0) (compare (List.compare_length_with [1] (-1)) 0)
