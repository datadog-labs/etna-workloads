# Rationale
One hunk in tree/src/services/completions.ts (createCompletionEntry): removed the `else if (parentNamedImportOrExport.kind === NamedImports)` branch that sets `insertText = \`${name} as ${name}_\`` for keyword names (await / non-contextual keywords). This corresponds to the fix's added block in the same function; without it, `import { ^ }` completions of keywords insert the bare keyword (invalid syntax).

SUMMARY: 1/1 oracle cases failing (0 fix-added).
