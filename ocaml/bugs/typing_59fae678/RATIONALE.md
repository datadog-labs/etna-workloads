# Rationale

Upstream fix 59fae6784c63 ("Fix detection of immediate64 types through unboxed
types") did several things. Most of it has already been reworked in 5.5.2:
`Typedecl_unboxed` is back to returning `type_expr option`, and `is_immediate`
and `maybe_pointer_type` already sit in `typeopt.ml`. Undoing those parts again
would only move code around without changing behaviour. The fix's one remaining
behavioural change, which every oracle test checks, is how `Typeopt.value_kind`
works.

## Hunk changed

### ocaml/typing/typeopt.ml — `value_kind`
Reverses the fix hunk:

    @@ -160,21 +166,21 @@ let bigarray_type_kind_and_layout env typ =

The fix made `value_kind` decide `Pintval` from `Ctype.immediacy` (after
`scrape_ty`), so any immediate type counts as an int: bool, constant-only
variants, `[@@immediate]` types, and immediate types reached through unboxed
types. The re-injected version keeps today's `scrape`, which returns an
option, but goes back to the old logic: only the predefined `int` and `char`
paths give `Pintval`; float, int32, int64 and nativeint give their usual kinds;
everything else gives `Pgenval`. So immediate types other than int/char lose
their `[int]` / `: int` value-kind annotations in the generated lambda. This
removes the immediacy-based detection the fix added.

## Commands and results
- `cd ocaml && make -j8 && make -j8 ocamltest`: failed with "inconsistent
  assumptions over implementation Stdlib__Hashtbl" when linking ocamltest.opt.
  This is the known incremental-build issue, so I did a clean rebuild.
- `cd ocaml && make clean && make -j8 && make -j8 ocamltest`: exit 0.
- `sh run-oracle.sh`:
  - tests/basic-modules/anonymous.ml => failed
  - tests/basic/patmatch_for_multiple.ml => failed
  - tests/translprim/array_spec.ml => failed
  - tests/translprim/comparison_table.ml => failed
  - tests/translprim/ref_spec.ml => failed
  (The failing diffs are the missing `: int` / `[int]` annotations the fix
  added to the expected output.)

RESULT: injected
