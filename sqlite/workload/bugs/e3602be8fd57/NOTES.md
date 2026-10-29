repro.sh builds a loadable extension that registers `like` with nArg=-1 (always returns 1), after
`PRAGMA case_sensitive_like` has installed the built-in 2/3-arg LIKE in db->aFunc.
Clean: the -1 function does not override them, output `1|ghijkl` / `2|ghijkl`.
Buggy: the -1 function overwrites the 2- and 3-arg entries, so the ESCAPE query returns all three rows
(`2|abcdef`, `2|ghijkl`, `2|mnopqr`) and the plain one stays `1|ghijkl`.
(Mirrors like-8.2/8.3; reproducer is a .sh because a C extension is needed to call create_function with -1.)
