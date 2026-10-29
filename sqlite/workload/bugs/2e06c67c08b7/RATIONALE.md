# Rationale

Fix (ticket #2525): in `sqlite3GenerateConstraintChecks`, the CHECK-constraint
failure path treated `OE_Replace` like `OE_Ignore` (silently skipping the row).
The fix limited that to `OE_Ignore`, so REPLACE falls back to FAIL/ABORT.

Change in `tree/src/insert.c` (CHECK constraint loop):
- `if( onError==OE_Ignore )` -> `if( onError==OE_Ignore || onError==OE_Replace )`:
  reverses the fix hunk directly.
- Removed `if( onError==OE_Replace ) onError = OE_Abort;`, the modern
  code that also converted REPLACE to ABORT (the fix's behaviour, expressed
  differently today). Without removing it the bug is not visible,
  because REPLACE would not reach the else branch... it is removed so the
  pre-fix semantics are fully restored.

Oracle failure: `check-6.12` (`REPLACE INTO t1 VALUES(6,7)` with a violated
CHECK) now succeeds silently, returning `0 {}` instead of
`1 {constraint failed}`.
