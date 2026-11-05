Both changes re-introduce the `S + L` integer overflow that fix.patch removed. In each function the overflow-safe `pg_add_s32_overflow` path is replaced by the original `E = S + L; if (E < S) error`.

1. `src/backend/utils/adt/varbit.c`, `bitsubstring()`. This traces to the varbit.c hunk of fix.patch. The explicit `l < 0` error and the overflow branch (which sets `e1 = bitlen + 1`) are gone. Plain `e = s + l` with an `e < s` check is back. A huge length now wraps negative, so it raises "negative substring length not allowed" instead of running to the end of the string.

2. `src/backend/utils/adt/varlena.c`, `bytea_substring()`. This traces to the bytea_substring hunk of fix.patch. It has the same revert: `E = S + L` with an `E < S` error replaces the overflow-safe branch. `substring(bytea, int, huge)` now errors instead of returning the rest of the value.

I did not revert the `text_substring` or detoast.c hunks. The bit and bytea reverts were enough to make the oracle fail.

Failing oracle cases: src/test/regress||bit and src/test/regress||strings.
