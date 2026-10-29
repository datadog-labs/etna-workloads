# Rationale

Fix hunk reversed: the `#ifdef SQLITE_FP_PRECISION_LIMIT` clamp in `sqlite3_str_vappendf()` (src/printf.c, `etFLOAT/etEXP/etGENERIC` case), which caps `precision` at 100,000,000 after the default precision is set.

In 3.54.1 the clamp is unconditional (the macro is now always defined), so I removed the `if( precision>SQLITE_FP_PRECISION_LIMIT ){ precision = ...; }` block. This restores the pre-fix behaviour: a huge precision such as `%.*g` with 2147483647 goes unclamped into the float conversion. The `SQLITE_FP_PRECISION_LIMIT` macro definition is left in place (now unused). The earlier clamp to `SQLITE_PRINTF_PRECISION_LIMIT` is only compiled when that macro is defined, so it does not cover this case.

Oracle failure: `printf-16.1` (`SELECT printf('%.*g',2147483647,0.01)` expected `0.01`) fails. All other 1438 cases pass.
