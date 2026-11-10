# Rationale
Single hunk in `tree/src/compiler/checker.ts` (serializeAsAlias/variable branch, `factory.createVariableDeclarationList`), corresponding to the only hunk of fix.diff.
The fix added a `flags` local so get-only accessors (Accessor without SetAccessor) are serialized as `const` even inside a ModuleDeclaration. I removed the local and restored the old inline `context.enclosingDeclaration?.kind === ModuleDeclaration ? Let : Const`, so JSDoc get-only accessors are emitted as `let` in namespaces again.

Final: SUMMARY: 1/6 oracle cases failing (0 fix-added).
