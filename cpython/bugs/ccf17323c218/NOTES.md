Reproducer: calls `locals()` inside an inlined list comprehension whose loop variable `k` has the same name as a cell variable (captured by a lambda) of the enclosing function.
Clean prints `0`. Buggy aborts (SIGABRT) with `Assertion PyCell_Check(value) failed` in framelocalsproxy_getval.
