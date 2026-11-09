Hunk: checker.ts, getBindingElementTypeFromParentType call in the destructured-parameter narrowing code (~line 30969).
Corresponds to the fix.diff hunk at "@@ -28445" which passed `/*noTupleBoundsCheck*/ true` (plus comment). Before the fix, the narrowed parent type (e.g. [3] from [1,2]|[3]) was bounds-checked, producing spurious out-of-bounds errors for elements. Now passes `false` again. The parameter/signature remain (they are used by other callers), so the other fix hunks need no change.
Summary: 1/6 oracle cases failing (0 fix-added).
