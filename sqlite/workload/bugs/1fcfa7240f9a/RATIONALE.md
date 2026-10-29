# Rationale

Fix (ticket 36fae083b4): non-zero floats with zero integer part (e.g. 0.5) must be true. The fix introduced `sqlite3VdbeBooleanValue()` and used it in OP_And/OP_Or, OP_Not, OP_If/OP_IfNot.

In 3.54.1 `sqlite3VdbeBooleanValue()` still exists, so I reverted its callers to the pre-fix code in `src/vdbe.c`:
- OP_And/OP_Or: restored the explicit `MEM_Null ? 2 : sqlite3VdbeIntValue(p)!=0` computation for v1/v2 (reverses the first hunk).
- OP_Not: restored `!sqlite3VdbeIntValue(pIn1)` (reverses the OP_Not hunk). 
OP_If/OP_IfNot are left alone (pre-fix they already used the real value for non-integers; the fix only refactored them).

Failing oracle cases (via check.sh): expr-14.1 (`x OR 0` differs from CASE for 0.5), expr-14.3 (`NOT x` for 0.5 gives 1 instead of 0), and expr-15.1.3 .. expr-15.6.5 (14 failures total).
