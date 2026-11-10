# Rationale
All hunks in src/compiler/transformers/legacyDecorators.ts:
1. Removed the `assignClassAliasInStaticBlock` computation and the `static { alias = this }` block insertion (fix hunk 2): for ES2022+ targets the alias is no longer reassigned before static initializers run, so static initializers referencing the class alias see it unassigned.
2. `varInitializer` again always assigns `classAlias = class {...}` (fix hunk 3 reverted).
3. Removed the `isClassStaticBlockDeclaration` import (fix hunk 1), needed since it became unused.

Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
