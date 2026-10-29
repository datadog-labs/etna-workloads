# Rationale

Fix: OFFSET on queries without a FROM clause (ticket 07d6a0453d4ed8).

Changes in tree/:
- src/select.c `codeOffset()`: restored `iOffset>0 && iContinue!=0`, reversing the fix's removal of `&& iContinue!=0`. With no FROM clause the OFFSET check is silently skipped (or uses a bogus label).
- src/where.c `sqlite3WhereBegin()`: `pWInfo->iBreak = sqlite3VdbeMakeLabel(pParse)` only, reversing the fix's `iBreak = iContinue = ...`. With zero loops, iContinue is never set (stays 0).
- Removed the fix's added asserts (`assert(iContinue!=0)` in selectInnerLoop and sqlite3WhereContinueLabel), as the pre-fix code lacked them.

Oracle: limit-14.1 (`SELECT 123 LIMIT 1 OFFSET 0`) fails with an assertion in resolveP2Values (unresolved label); the rest of limit-14.x guard the same case (OFFSET ignored without FROM).
