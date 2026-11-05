# Rationale

Changed file: `src/interfaces/ecpg/ecpglib/execute.c`, function `ecpg_store_input`.

Hunks: the `ECPGt_short`, `ECPGt_unsigned_short`, `ECPGt_int` and `ECPGt_unsigned_int` cases (the first four array-building branches).
- Each builds the array literal. Reverted from `"{"` ... `"}"` back to `"array ["` ... `"]"`.
- Traces to fix.patch's `execute.c` hunks that replace `strcpy(mallocedval, "array [")` / `"]"` with `"{"` / `"}"` in those same cases.
- Why it brings the bug back: ecpg sends the host array as a text parameter. The server needs array literal syntax `{1,2,3}`. `array [1,2,3]` is SQL constructor syntax and is not valid as a text input value. Inserting an integer host array therefore fails or gives wrong data.

Oracle cases that fail (confirmed by running the oracle): `src/interfaces/ecpg||sql/array`.
`sql/oldexec` still passes.
