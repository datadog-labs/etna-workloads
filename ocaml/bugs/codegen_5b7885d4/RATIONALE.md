# Rationale
The fix's only implementation hunk (`asmcomp/amd64/emit.mlp`, `@@ -315,6 +315,7 @@ emit_call_gc`) has no
counterpart in today's code (the GC protocol changed). The test-visible part of the fix is the
`field` -> `field_imm` change in `translprim/comparison_table.ml.reference`
(`@@ -229,11 +229,12 @@` and `@@ -277,10 +278,11 @@`). I reversed it: immutable field loads are again
generated as mutable `Pfield`.

Hunks:
- `lambda/matching.ml` (~line 2291): `Pfield (pos, Pointer, Immutable)` -> `Mutable` for tuple/constructor
  argument field access (reverses `(field_imm 0 param)` -> `(field 0 param)` hunks).
- `lambda/lambda.ml` line 720 (`transl_address`): `Immutable` -> `Mutable` for module field access
  (reverses `(field_imm 12 (global List!))` -> `(field 12 ...)`).

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), `sh run-oracle.sh`:
comparison_table.ml => failed, extensions.ml => passed.
