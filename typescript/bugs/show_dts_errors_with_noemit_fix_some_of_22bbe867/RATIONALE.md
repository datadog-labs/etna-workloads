# Rationale
Changed only `src/compiler/watch.ts`, corresponding to the watch.ts hunks of fix.diff:
- Removed the block in `emitFilesAndReportErrors` that, when `noEmit` and declaration emit are on, adds `program.getDeclarationDiagnostics(...)` to the reported diagnostics (the fix added this). Without it, `--noEmit` hides d.ts errors again — the bug the fix's title describes.
- Removed the now-unused `getEmitDeclarations` import (the fix added it).

Final check.sh: SUMMARY: 22/687 oracle cases failing (8 fix-added).
