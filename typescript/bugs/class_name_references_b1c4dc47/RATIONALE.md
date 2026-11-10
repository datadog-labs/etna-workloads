# Changed hunks

1. `tree/src/compiler/checker.ts`, checkIdentifier class-reference marking: corresponds to the fix.diff hunk at `@@ -28001,38 +28000,20 @@`. Restores the pre-fix logic. Only references inside a legacy-decorated class declaration, or inside static properties or static blocks of a class expression, are marked as class constructor references. The fix replaced this with marking for any class-like declaration. Without the broader marking, class-name references in static elements of undecorated class declarations, private-name classes and similar cases are not aliased, so the emitted JS differs from the baselines. Today's flag names (`ContainsConstructorReference`/`ConstructorReference`) are used because the old flags no longer exist.
2. `checker.ts` import list: re-adds `nodeIsDecorated`, which corresponds to the fix.diff import hunk `@@ -851,7 +851,6 @@`. The old logic needs it.

The transformer and types.ts hunks were left alone. Today's code already uses the unified flags, and those hunks only renamed flags.

Final check.sh summary: SUMMARY: 35/240 oracle cases failing (1 fix-added).
