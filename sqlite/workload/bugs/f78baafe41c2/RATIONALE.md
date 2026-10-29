# Rationale

Fix (dan, 2012-12-06): constant refactoring (hoisting literals into init code) must not
happen for statements in trigger programs, as it does not for top-level statements after
the first loop is opened. In 3.54.1 this is expressed as `Parse.okConstFactor`, which is
set only for top-level parses and is asserted 0 in trigger program coding. The old
cookieGoto flag no longer exists, so the build.c/trigger.c hunks are re-expressed:

- `src/select.c` `sqlite3GetVdbe()`: removed the `pParse->pToplevel==0` condition so the
  trigger sub-parse also gets `okConstFactor = 1`. This reverses the fix's effect
  (trigger statements get the same restriction as top-level ones, i.e. no factoring).
- `src/trigger.c` `codeTriggerProgram()`: removed `assert( pParse->okConstFactor==0 )`,
  the modern counterpart of the fix's per-step reset of the flag in the same loop.

Result: constants in trigger statements are factored into `pConstExpr`, which is never
emitted for the trigger sub-program, so the registers are uninitialised.

Oracle: triggerC.test fails starting at triggerC-1.9
(`sqlite3VdbeMemStringify` assertion from an uninitialised constant register); the run
aborts, so later cases (including triggerC-14.1) don't complete.
