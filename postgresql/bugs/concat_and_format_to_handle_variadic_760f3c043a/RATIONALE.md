# Rationale

File: src/backend/utils/adt/varlena.c

- `concat_internal()`: removed the `get_fn_expr_variadic()` block that passes
  `concat(VARIADIC array)` to `array_to_text_internal()` (fix_impl hunk adding that block).
  Now a VARIADIC-labeled array is treated as one ordinary argument, so concat/concat_ws
  output the array's text form instead of concatenating its elements.
- `text_format()`: removed the VARIADIC-expansion block (fix_impl hunk adding it); always
  uses `nargs = PG_NARGS()` and `funcvariadic = false`. `format('%s', VARIADIC arr)` now
  formats the array as one argument, and "too few arguments" errors appear.

Failing oracle case: src/test/regress||text
