`repro.sql` runs the `regexp_instr` queries added to `regexp_instr.slt` by the fix: empty patterns, an empty input string, a start position at the terminal boundary, and the zero-width pattern `x*`.

- df-clean returns `1 1 4 0 2 4 NULL`.
- df-buggy returns `0` for every column except the last, because it returns 0 early for an empty pattern or an empty value. It also can't match at the terminal boundary, so `regexp_instr('abc', 'x*', 4)` returns 0 instead of 4.
