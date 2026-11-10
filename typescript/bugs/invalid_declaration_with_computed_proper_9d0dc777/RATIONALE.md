# Rationale
Single hunk in `tree/src/compiler/transformers/declarations.ts` (`visitBindingElement`): removed the
`if (elem.propertyName && isComputedPropertyName(...) && isEntityNameExpression(...)) checkEntityNameVisibility(...)`
block, matching the fix.diff hunk that added it. Without it, imported symbols used as computed keys in
binding patterns are not checked/marked visible, so the declaration emit lacks the needed import (invalid .d.ts).
The imports (`isComputedPropertyName`, `isEntityNameExpression`) are still used elsewhere, so the build passes.

Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
