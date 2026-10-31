Defines a `Flag` with an assigned negative value (`D = ~A`) and prints the members and `X.D`.
Clean: `X.D` is an alias of `X.B` (value 2). Buggy: the negative value isn't inverted
at class creation, so `X.D` is a separate member `<X.D: -2>` with value -2.
