# Rationale
Hunk: ocaml/typing/typecore.ml, `collect_apply_args`: removed the
`if not optional && is_optional l' then Location.prerr_warning ... Nonoptional_label` check
when a non-optional parameter is matched by a `?x:` argument.
Reverses fix.diff hunk `@@ -2899,7 +2899,9 @@ and type_application env funct sargs`
(which rejected `optional = Required && is_optional l'`; in today's code that
diagnostic is the warning 43 rather than an error). Now `f ?x:0` on `f ~x` is silently accepted (PR#5835).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; after final `make clean` rebuild,
tests/typing-misc/labels.ml fails (missing Warning 43).
