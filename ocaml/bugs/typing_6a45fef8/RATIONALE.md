# Rationale
File: ocaml/typing/env.ml (`lookup_all_args`, and its call in `lookup_apply`).
The fix (`@@ -101,8 +101,8 @@ let rec narrow_unbound_lid_error` in typing/typetexp.ml) made an unbound module inside a
functor application path (`F(Does_not_exist).t`) get reported as "Unbound module Does_not_exist"
at the offending module. That code has since moved into Env's lookup_apply. I re-introduced the
bug by making the argument lookup in `lookup_all_args` use the location of the whole application
instead of the argument's own location, so the error is reported against the wrong thing.
(`~loc` parameter added, argument's loc ignored.)
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/typing-modules/pr7207.ml fails (location of error differs).
