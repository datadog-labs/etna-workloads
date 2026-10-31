Executes `select ?1, ?2` and `select ?2, ?1` with a sequence of params (gh-117995).
Clean: returns `[(1, 2)]` and `[(2, 1)]`. Buggy: raises ProgrammingError claiming `?1` is a named parameter.
