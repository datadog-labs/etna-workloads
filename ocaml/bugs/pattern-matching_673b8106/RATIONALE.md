# Rationale

## Hunk 1: ocaml/lambda/matching.ml, `mk_failaction_pos`, `| None ->` branch
Reverses fix hunk `@@ -3023,15 +3023,15 @@ let mk_failaction_pos partial seen ctx defs =`.
Today's code matches on `arg_partial` with `Arg { global = Total; _ }` / `Arg { global = Partial; _ }`.
I changed both to `current`, so the "no exit left" case uses the local partiality again.
A final exit is then generated for failing patterns that can't actually occur. This
brings back the spurious Match_failure clauses.

## Hunk 2 (compensation, not in fix.diff): ocaml/lambda/matching.ml, `compile_matching`
I removed the emission of warning 74 (Degraded_to_partial_match), leaving `ignore loc`.
With hunk 1 alone, the stdlib and compiler are built with `-warn-error +A`.
They hit warning 74 in many matches, such as camlinternalFormat.ml, type_immediacy.ml and path.ml.
The build then fails. The attributes `[@warning "-74"]` had no effect there, so I silenced the warning at its source.
This hunk has no counterpart in fix.diff. It exists only to keep the build working.
Hunk 1 is the actual bug.

## Commands
- `make -j8 && make -j8 ocamltest` after `make clean`: succeeded.
- `sh run-oracle.sh`: `partiality.ml` FAILED. The expected output has no Match_failure clause, but the output now contains the spurious one.
- Hunk 1 alone: the build failed with warning 74 errors.
