# Rationale
Hunk: ocaml/typing/typecore.ml, `vb_pat_constraint`: for a `let`/`let rec` binding `x : T = e` where T is an arrow
returning an object type, the pattern is no longer wrapped in a type constraint (only the expression is constrained).
Reverses fix.diff hunk `@@ -1572,8 +1572,18 @@ lident_list:` in parsing/parser.mly, which added the
`val_ident type_constraint EQUAL seq_expr` rule that put a (poly) constraint on the pattern too (PR#7344).
Today's parser/AST carries this as `pvb_constraint`, so the pattern-side constraint lives in `vb_pat_constraint`.
The narrow condition (arrow to object) was needed because dropping it for all types broke compiling the compiler
itself (typing/shape.ml relies on it).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`: tests/typing-poly/poly.ml fails
(PR#7344 test: "This constant has type string but an expression was expected of type int").
