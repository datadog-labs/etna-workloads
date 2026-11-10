# Rationale
Single hunk in `tree/src/compiler/checker.ts` (checkIdentifier, dependent destructured variables), matching the single fix.diff hunk:
- Removed `rootDeclaration = getRootDeclaration(parent)`; the const/parameter check and the `isSomeSymbolAssigned` check use `parent` and `declaration` again. For nested binding patterns `parent` is a BindingElement, so the narrowing-from-parent-type path is skipped and dependent variables in nested patterns are no longer narrowed.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
