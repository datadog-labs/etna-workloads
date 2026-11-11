# Rationale
One hunk, ocaml/typing/ctype.ml, `allow_recursive_equations`:
was `!Clflags.recursive_types || in_counterexample uenv`, now `!Clflags.recursive_types || (match uenv with Pattern _ -> true | Expression _ -> false)`.
Reverses fix.diff hunks `@@ -1796,7 +1799,8 @@ let merge r b` (occur: `!umode = Pattern && !allow_recursive_equation` -> `!umode = Pattern`) and the matching local_non_recursive_abbrev `allow_rec` hunk: recursive types are again permitted in any pattern-mode unification, not only when explicitly allowed (today: counterexample mode). The plumbing hunks (~allow_recursive args) are today folded into the uenv/in_counterexample design, so only this predicate needed changing.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> pr6174, pr7016, pr7902 fail; pr7374 passes.
