# Rationale
One hunk, tree/src/compiler/checker.ts (serializeAsAlias/property-as-variable path in serializeSymbolWorker):
the fix changed the variable statement flags from `Const` to `Let` when `context.enclosingDeclaration` is a ModuleDeclaration.
Today's code computes `flags` with that condition (plus an accessor check); I replaced it with `NodeFlags.Const`, so
expando/namespace members are again emitted as `const` instead of `let` inside namespaces.

SUMMARY: 43/260 oracle cases failing (1 fix-added).
