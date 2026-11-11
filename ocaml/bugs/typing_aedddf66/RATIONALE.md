# Rationale

## Hunk changed

**File:** `ocaml/typing/typetexp.ml`, in `transl_type_aux`, case `Ptyp_class(lid, stl)` (the `#t` type syntax).

Before:
    let path, decl = Env.lookup_cltype ~loc:lid.loc lid.txt env in
After:
    let path, decl = Env.lookup_cltype ~use:false ~loc:lid.loc lid.txt env in

**What it does:** when `#t` is translated, the type now gets looked up without being
marked as used (`~use:false`). That means the declaration and any `open` that brought
`t` into scope are never marked as used, so you get a spurious "unused open M"
(warning 33) and "unused type t" (warning 34) whenever `#t` is the only use.

**Fix hunk it reverses:** `@@ -266,6 +266,7 @@ and transl_type_aux env policy styp =`
in `typing/typetexp.ml`. That hunk added
`ignore(Env.lookup_type ~loc:lid.loc lid.txt env);` to the `#t` branch of
`Ptyp_class`. In 2019 the branch looked the name up without marking it used, and the
extra lookup was there only to mark the type and the open as used. Since then the old
`#t`-as-polymorphic-variant branch has been removed. The only lookup left in
`Ptyp_class` is `Env.lookup_cltype`, which is now the thing that marks usage. Turning
off its `use` brings back the same missing mark and the same spurious warnings.
The fix's test hunk (open_warnings.ml, T6) was about this exact symptom. That test
case is gone today, but T7/T8 in the same file cover `#t` the same way.

## Commands and results
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
  → build OK; `tests/typing-warnings/open_warnings.ml` => failed (new Warning 34
  "unused type t" and Warning 33 "unused open M" for modules T7 and T8).
- Final: `make clean && make -j8 && make -j8 ocamltest` → exit 0;
  `sh run-oracle.sh` → `open_warnings.ml => failed` (same diff).

RESULT: injected
