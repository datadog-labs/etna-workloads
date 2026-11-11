# Rationale

File: ocaml/lambda/translcore.ml, function `transl_curried_function`.

The upstream fix (`@@ -88,20 +88,41 @@ ... let rec push_defaults ...` and the hunk
`@@ -145,13 +157,13 @@` that wraps the bindings) made optional-argument defaults
be bound with correct scoping and order relative to the other parameters.
`push_defaults` no longer exists in 5.5. Defaults are now handled in
`transl_curried_function` through `Tparam_optional_default`, and each default is
wrapped outside the later parameter patterns.

The change: the `Tparam_optional_default` bindings are applied first, directly
around the function body. A second fold then wraps the parameter pattern
matches around them. As a result the default expressions are evaluated after
the later patterns have been matched. This is the same wrong order that the old
`push_defaults` produced.

For `let f ?(y = assert false) (lazy e) = ...`, the lazy pattern is now forced
before the default is evaluated. pr10338.ml prints an extra "hello".

Commands run:
- `make -j8 && make -j8 ocamltest` hit an "inconsistent assumptions" error
  (incremental build).
- `make clean && make -j8 && make -j8 ocamltest` succeeded.
- `sh run-oracle.sh`: pr10338.ml failed in both native and bytecode. The output
  has an extra `hello` line.
