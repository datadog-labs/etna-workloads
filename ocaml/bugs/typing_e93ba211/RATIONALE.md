Reverts the fix's "two falses to trues" (type_apply_arg) in the current code.
- typing/typecore.ml type_apply_arg: both `instance_poly_fixed vars ...` / `instance_poly_fixed vars0 ...` calls now pass `~fixed:false` (fix hunk `@@ -5942,10 +5942,10 @@ and type_apply_arg`).
- typing/ctype.ml / ctype.mli: instance_poly_fixed gets an optional `?(fixed=true)` argument so the non-fixed pair-returning form (pre-fix `instance_poly ~fixed:false`) is expressible (fix hunks `@@ -1507,9 +1507,14 @@ instance_poly'` and the ctype.mli hunk).
Ran: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh -> typing-poly/poly_params.ml fails.
