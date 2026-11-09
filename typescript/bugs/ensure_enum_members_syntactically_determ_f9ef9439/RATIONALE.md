Hunk: tree/src/compiler/transformers/ts.ts (transformEnumMember): outerAssignment no longer skips the reverse mapping when `evaluated.isSyntacticallyString`; only when the evaluated value is a string.
Corresponds to fix.diff ts.ts hunk (StringLiteral kind -> isSyntacticallyString). The utilities.ts helper/import hunks have no equivalent today (evaluator already carries isSyntacticallyString), so only the use site was reverted.
Syntactically-string but non-evaluable members (e.g. `"a" + foo()`) get reverse mappings again.
Final: SUMMARY: 4/678 oracle cases failing (2 fix-added).
