Single hunk in checker.ts (serializeAsAlias, ExportSpecifier case): removed the `if (specifier) { ... verbatimTargetName = InternalSymbolName.Default }` block, matching the fix.diff hunk that added it. Without it, `export { default } from "./x"` re-exports in JS declaration emit lose the verbatim `default` target name.
Final check.sh: SUMMARY: 1/6 oracle cases failing (1 fix-added).
