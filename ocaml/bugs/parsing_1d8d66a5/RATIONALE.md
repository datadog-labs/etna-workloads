# Rationale
Fix reversed: `@@ -1267,7 +1267,7 @@ and_class_type_declaration:` in parsing/parser.mly (`expr SEMI { reloc_exp $1 }` -> `{ $1 }`).
In today's code the rule is `fun_expr SEMI` in `fun_seq_expr`.

Hunks:
1. ocaml/parsing/parser.mly line 2357: `{ $1 }` -> `{ reloc_exp ~loc:$sloc $1 }` (trailing `;` is again included in the expression location).
2. ocaml/boot/menhir/parser.ml (~line 21174): the matching generated action `( _1 )` -> `( reloc_exp ~loc:(_startpos, _endpos) _1 )`.

The fix's test .reference changes (4-14 vs 4-13) are in testsuite and untouched.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: pr6920_why_swallow.ml fails (bytecode and native: "characters 4-14" instead of "4-13").
