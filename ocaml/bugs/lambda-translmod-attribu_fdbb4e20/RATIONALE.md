# Rationale
Fix PR#7538: attributes on alias modules (Mp_absent) were never checked, so misplaced `[@inlined]` warnings were missing for e.g. `module I = Set.Make [@inlined]`.
In today's code the check function no longer exists; unused attributes are warned about unless something looks them up. Re-introduction: in `ocaml/lambda/translmod.ml` the `Tstr_module ({mb_presence=Mp_absent} ...)` cases now look up the inline/inlined attributes (marking them used, so no warning):
- `transl_structure`: reverses hunk `@@ -666,7 +666,11 @@ and transl_structure` (which handled Mp_absent with attribute checks).
- `transl_store_structure`: reverses hunk `@@ -1120,7 +1124,11 @@ let transl_store_structure`.
The third hunk (`transl_toplevel_item`) was not changed.
Hmm: the semantics are inverted vs. the original (the original added checks to warn; today's code warns by default), so the lookups suppress the warning, giving the same observable bug.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/warnings/w53.ml failed (missing warnings for lines 193/194).
