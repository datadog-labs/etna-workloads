# Rationale

The fix avoids a segfault when NULL is passed as the first argument to the
SQL scalar function `fts3_tokenizer()`. The function (`scalarFunc` in the
fix, now named `fts3TokenizerFunc` in version-3.54.1) still contains both
code paths the fix touched in `ext/fts3/fts3_tokenizer.c`, so both hunks were
reversed directly, with no need to re-derive the logic.

## Hunk 1 — two-argument form

Fix hunk:
```
-    if( n!=sizeof(pPtr) ){
+    if( zName==0 || n!=sizeof(pPtr) ){
```

Reverted by removing the `zName==0 ||` disjunct, restoring:
```
if( n!=sizeof(pPtr) ){
```

Effect: `fts3_tokenizer(NULL, X'...')` with a correctly-sized blob no longer
is rejected up front. `zName` (from `sqlite3_value_text(argv[0])`) is NULL,
and execution falls through to `sqlite3Fts3HashInsert(pHash, (void*)zName,
nName, pPtr)` with a NULL key.

## Hunk 2 — one-argument form

Fix hunk:
```
-    pPtr = sqlite3Fts3HashFind(pHash, zName, nName);
+    if( zName ){
+      pPtr = sqlite3Fts3HashFind(pHash, zName, nName);
+    }
```

Reverted by removing the `if( zName )` guard, restoring the unconditional
call:
```
pPtr = sqlite3Fts3HashFind(pHash, zName, nName);
```

Effect: `fts3_tokenizer(NULL)` now calls `sqlite3Fts3HashFind` with a NULL
key instead of skipping the lookup and reporting "unknown tokenizer".

These are the only two implementation hunks in `fix.patch` (the rest of the
patch only touches `manifest`, `manifest.uuid`, and the test file, which are
excluded per the task instructions). No other code path in version-3.54.1
covers this case, so no second revert was needed.

## Oracle result

Running `./check.sh` against `test/fts3atoken.test`:

```
test/fts3atoken.test: 3 of 24 oracle cases failing:
  ['fts3atoken-6.2.1', 'fts3atoken-6.2.2', 'fts3atoken-6.2.3']
(incomplete run: crash, assert or timeout)
```

These are exactly the three test cases the fix's commit added to guard
against this bug:

- `fts3atoken-6.2.1`: `SELECT fts3_tokenizer(NULL);` — expected to report
  "unknown tokenizer: ", instead crashes (NULL `zName` passed into
  `sqlite3Fts3HashFind`/the error-message `sqlite3_mprintf("%s", zName)`
  path).
- `fts3atoken-6.2.2` / `fts3atoken-6.2.3`: `SELECT fts3_tokenizer(NULL,
  X'...')` — expected to report "argument type mismatch", instead a NULL
  `zName` reaches `sqlite3Fts3HashInsert`, which segfaults/crashes instead
  of erroring out, and the test run is cut short ("incomplete run: crash,
  assert or timeout").

This matches the historical bug and the fix's own regression tests as the
oracle.
