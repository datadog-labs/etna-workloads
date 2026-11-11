let f x = ignore (match x with `A|`B -> 1); ignore (x : [`A])
