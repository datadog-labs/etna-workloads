Input narrows a generic `T extends Array<unknown> | undefined` with `typeof arg !== "undefined"`, then iterates/spreads it.
Clean: no errors. Injected: TS18048 "'arg' is possibly 'undefined'" on the for-of and TS2488 on the spread,
because the !== "undefined" branch no longer removes undefined from the constraint (getTypeWithFacts instead of getAdjustedTypeWithFacts).
