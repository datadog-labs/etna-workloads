# Rationale

## Hunk (1 hunk): ocaml/typing/ctype.ml, `update_level`
Today the `Tfield` case is
`Tfield(lab,_,ty1,_) when lab = dummy_method && level < get_scope ty1 -> raise_escape_exn Self`.
I changed it to `Tfield(lab,_,_,_) when lab = dummy_method -> raise_escape_exn Self`,
so updating the level of a type containing the self-type dummy method always raises
an escape error, instead of only when the level would really be exceeded.

Reverses this fix.diff hunk (typing/ctype.ml):
`@@ -720,7 +732,8 @@ let rec update_level env level ty =`, which changed
`| Tfield(lab, _, _, _) when lab = dummy_method ->` to
`| Tfield(lab, _, ty1, _) when lab = dummy_method && (repr ty1).level > level->`.
The condition is now written with scopes (`get_scope`) rather than `(repr ty1).level`,
so I re-expressed the revert by dropping the extra condition.

## Build/test
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`: `tests/typing-objects/Tests.ml` fails.
- Final: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
  `tests/typing-objects/Tests.ml` => failed (both the plain run and the expect run).

I tried two other candidates first (the `Tfield`/`Tnil` unify recursion and the
`Reither` fixed redo in ctype.ml). They produced no oracle failure, and I reverted both.

RESULT: injected
