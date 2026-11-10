# Rationale
One hunk, in `resolveMappedTypeMembers` (src/compiler/checker.ts), corresponding to the fix's first/second hunks (`shouldLinkPropDeclarations` / `isFilteringMappedType`).
Today's code computes `shouldLinkPropDeclarations` via `getMappedTypeNameTypeKind(mappedType)`, which checks the target's name type against the target's type parameter. I changed it to the pre-fix form `!nameType || isTypeAssignableTo(nameType, typeParameter)`. Here `nameType` comes from the target but `typeParameter` comes from the instantiated type. For instantiated generic filtering mapped types the check fails, so property declarations are dropped and go-to-definition returns nothing.

check.sh: SUMMARY: 1/1 oracle cases failing (1 fix-added).
