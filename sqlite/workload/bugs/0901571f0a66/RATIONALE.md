# Rationale

Fix: coalesce()/ifnull()/iif() pass subtypes through from their arguments, so they
need SQLITE_RESULT_SUBTYPE in their FuncDef flags.

## Hunks
- fix `src/func.c` (add SQLITE_RESULT_SUBTYPE to ifnull/coalesce/iif): in 3.54.1 these
  INLINE_FUNC entries (func.c ~3450, 3547-3549) already have flags 0, so the flag is
  already absent. The case is still covered by a different path: `exprNodeCanReturnSubtype`
  in `src/expr.c` returns WRC_Continue for functions without the flag, so it descends
  into the arguments and finds json() inside coalesce(). This is the same defect.
- `src/expr.c` `exprNodeCanReturnSubtype`: last return changed from WRC_Continue to
  WRC_Prune. A function without SQLITE_RESULT_SUBTYPE is then treated as never
  returning a subtype, even when it passes one through from an argument. This is the
  pre-fix behaviour for coalesce/ifnull/iif, and it affects only those inline functions.
  Other functions clear subtypes in sqlite3_result_value.

## Oracle failures
indexexpr1-2211, 2221, 2231, 2241, 2251, 2261 (expression index on
coalesce/iif/ifnull of json(y)) return NULL instead of 5. The subtype is lost when the
indexed expression value replaces the original expression inside json_insert().
