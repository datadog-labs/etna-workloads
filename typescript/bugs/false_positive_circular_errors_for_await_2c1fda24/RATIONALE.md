# Rationale
Single file: tree/src/compiler/checker.ts, getQuickTypeOfExpression.
- Removed the `isAwaitExpression(expr)` branch (fix hunk 3), so await expressions get no quick type and fall back to full checking, causing false circularity errors in CFA loops.
- Restored the old call branch shape (`const type = ...; if (type) return type;`, fix hunk 3 second part), reversing the "return directly" change.
- The `isAwaitExpression` import (fix hunk 1) is still used elsewhere in checker.ts, so kept. The return type annotation (hunk 2) is harmless and kept.

Final: SUMMARY: 2/18 oracle cases failing (2 fix-added).
