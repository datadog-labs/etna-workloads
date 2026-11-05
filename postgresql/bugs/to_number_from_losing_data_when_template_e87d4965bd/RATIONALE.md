# Rationale

All changes are in `src/backend/utils/adt/formatting.c`, function `NUM_processor()`.
They trace to the `NUM_processor` hunks of fix_impl.patch and undo them in the from-char (to_number) paths:

- `NUM_COMMA` (from_char): removed `if (*Np->inout_p != ',') continue;`.
- `NUM_G` (from_char): removed the check that input matches L_thousands_sep. It now unconditionally skips `pattern_len` bytes.
- `NUM_L` (from_char): no longer calls `NUM_eat_non_data_chars`. It skips `strlen(pattern)` bytes blindly.
- `NUM_th` / `NUM_TH`: from_char skips one byte unconditionally, instead of eating 2 non-data characters.
- `NUM_MI` / `NUM_PL` / `NUM_SG`: removed the else branches that eat a non-data char without consuming data.

Together, to_number() skips input for non-matching templates and so loses digits. For example, `to_number('123', 'MI999')` or a `L`/`TH` template swallows data characters.

The helper `NUM_eat_non_data_chars` is left defined but is now unused, which is harmless.

Failing oracle case: src/test/regress||numeric
