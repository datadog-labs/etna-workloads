# Rationale

## Reverted hunk

Fix hunk (src/bitops.c, `bitcountCommand`):

```
-        if ((unsigned)end >= strlen) end = strlen-1;
+        if (end >= strlen) end = strlen-1;
```

In Valkey 9.0.7 the `BITCOUNT`/`BITPOS` range clamping code has moved and been
reworked (it now supports `BIT`/`BYTE` ranges and is shared with `bitposCommand`),
but the equivalent clamp line still exists twice in `src/bitops.c`:

```c
if (end >= totlen) end = totlen - 1;
```

(once in `bitcountCommand`, once in `bitposCommand`, both operating on
`long long end` / `long long totlen`).

I changed the occurrence in `bitcountCommand` back to:

```c
if ((unsigned)end >= totlen) end = totlen - 1;
```

This is the same defect the fix removed: casting `end` (a 64-bit `long long`)
to `unsigned` (32-bit) truncates large values. With `end = 4294967296`
(`UINT_MAX + 1`), `(unsigned)end` truncates to `0`, which is `< totlen`, so
the clamp is skipped and `end` remains `4294967296`. The subsequent code
computes `bytes = (long)(end - start + 1)` and calls
`serverPopcount(p + start, bytes)` with a huge out-of-bounds byte count,
causing a segfault/out-of-bounds read — exactly the crash the original
upstream commit fixed.

I left `bitposCommand`'s identical clamp line untouched: the upstream fix
commit only touched `bitcountCommand`, and the oracle's regression test
(`BITCOUNT regression test for github issue #582`) only targets `BITCOUNT`.

I did not touch the `long start, end, strlen;` / `size_t strlen;` type-change
hunk, since 9.0.7 already uses `long`/`long long` throughout; that hunk has
no behavioral effect to reintroduce on its own — the behavioral bug is
entirely carried by the `(unsigned)` cast reintroduced above.

## Oracle result

Running `./check.sh` reproduces a crash: the test run aborts mid-file with
`couldn't open socket: connection refused` after the `BITCOUNT misaligned
prefix` test, indicating the server process crashed (segfault) while running
the bitops suite, consistent with the out-of-bounds read described above.
Every test after the crash point, including `BITCOUNT regression test for
github issue #582`, is reported as failing since the server never responds.
