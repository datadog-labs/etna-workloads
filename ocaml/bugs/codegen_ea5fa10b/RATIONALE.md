# Rationale
One hunk, in `ocaml/asmcomp/selectgen.ml`, method `emit_parts`. It reverses the fix.diff hunk
`@@ -752,8 +873,51 @@ method private bind_let ...` and the related `@@ -776,18 +940,27 @@ method private emit_parts`.
That fix made `emit_parts` decide, using the (co)effects of the expressions evaluated after it,
whether it may defer a mutable read. I changed the `Coeffect.Read_mutable` case to always
return `true`, so a mutable read is deferred even when later-evaluated code has arbitrary effects.
This restores the pre-fix reordering. `f (incr i; !i) !i` then prints a different result in native code.

Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`.
Result: eval_order_1 fails in native mode. eval_order_3 passes.
I then ran `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh again. eval_order_1 still fails.
