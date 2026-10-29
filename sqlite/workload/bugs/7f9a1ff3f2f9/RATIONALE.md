# Rationale

## What the fix did

`fix.patch` changes `jsonbPayloadSize()` in `src/json.c`. The bounds check:

```
if( i+sz+n > pParse->nBlob
 && i+sz+n > pParse->nBlob-pParse->delta
){
```

was changed to:

```
if( (i64)i+sz+n > pParse->nBlob
 && (i64)i+sz+n > pParse->nBlob-pParse->delta
){
```

`i`, `sz`, and `n` are all `u32`. For a corrupt JSONB blob, `sz` (the
decoded payload size) can be close to `UINT32_MAX`. Without the `(i64)`
cast, `i+sz+n` is computed in 32-bit unsigned arithmetic and can wrap
around to a small value, so the overflow/overread check silently passes
even though the real (64-bit) end offset is far beyond the end of the
blob. The caller then reads/copies `sz` bytes starting at `i`, overrunning
the buffer.

## Where this check lives in 3.54.1

In version-3.54.1 this same check (already written with `(i64)` casts)
occurs in four places in `src/json.c`:

1. `jsonbPayloadSizeWide()` — the tail-recursive helper that decodes the
   2/4/8-byte payload-size encodings (type nibbles 13/14/15). This is the
   direct descendant of the function the fix patched.
2. `jsonbPayloadSize()` — the main entry point, for the single-byte and
   12-nibble (1-byte extra) size encodings.
3 & 4. Two more copies inside an `#if SQLITE_USES_INLINE` block that
   provides inline versions of the same two functions for a hot call site.

All four are the same defect: the same bounds-check formula, duplicated
because of the wide/narrow split and the inline/non-inline split. They
all guard against the identical corrupt-blob overread, so reverting all
of them is reverting one defect, not inventing new ones.

## Changes made

In `tree/src/json.c`, in `jsonbPayloadSizeWide()` and in the inline copy
of the wide-size check, the `(i64)` casts on both operands of the `&&`
were removed, restoring the pre-fix 32-bit arithmetic:

```
if( i+sz+n > pParse->nBlob
 && i+sz+n > pParse->nBlob-pParse->delta  /*NO_TEST*/
){
```

(the narrow-size checks in `jsonbPayloadSize()` and its inline twin were
left with the `(i64)` cast, since `sz` there is at most 255 and cannot
overflow a `u32` addition — the fix's test case targets the wide-size
path, which does need a large `sz` to trigger the wraparound).

Each changed line traces directly to a hunk of `fix.patch`: it undoes
exactly the `(i64)` cast the fix introduced, nothing else.

## Oracle result

Running `./check.sh` against `test/jsonb01.test`:

```
== test/jsonb01.test: 3 of 40 oracle cases failing: ['jsonb01-2.0', 'jsonb01-3.0', 'jsonb01-3.1'] (incomplete run: crash, assert or timeout)
```

`jsonb01-2.0` is exactly the regression test the fix added
(`SELECT x'8ce6ffffffff171333' -> '$';`, expected `{1 {malformed JSON}}`).
With the bug reintroduced, the 32-bit wraparound lets the oversized
payload size through the bounds check, and the subsequent read walks off
the end of the (under-allocated) blob buffer, producing a crash/assert
instead of the expected "malformed JSON" error — so the run aborts before
reaching the later test cases in the file (`jsonb01-3.0`, `jsonb01-3.1`
are reported failing only because the test run terminated early).
