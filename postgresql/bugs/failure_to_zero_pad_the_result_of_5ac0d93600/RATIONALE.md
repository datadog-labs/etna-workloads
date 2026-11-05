# Rationale
- File/function: src/backend/utils/adt/varbit.c, bitshiftright().
- Traces to the fix_impl.patch hunk `@@ -1507 ... bitshiftright`, which added `VARBIT_PAD_LAST(result, r);` after the shift loop. I removed that call (and its comment), so 1-bits shifted into the pad bits of the last byte are no longer zeroed.
- Only that hunk is reversed. The other hunks are macro refactoring and comments, and the current code still has working padding there.

Failing oracle case: src/test/regress||bit
