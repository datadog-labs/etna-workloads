# Rationale
All changes are in tree/src/services/inlayHints.ts (CRLF preserved).

- Removed the generic `if (isLiteralExpression(node)) { parts.push({ text: getLiteralText(node) }); return; }` in visitForDisplayParts and re-added the old explicit `case NumericLiteral` (raw text) and `case StringLiteral` (`"${text}"`). This matches the fix.diff hunk that removed those cases in favour of the generic branch. Result: bigint literals fall through unhandled (no hint text), and string literals ignore quote preference and escaping.
- Added the `NumericLiteral` and `StringLiteral` imports, which the restored cases need (counterpart of the fix's import hunks).
- Left `getLiteralText`/`quotePreference` in place because today's code also uses them for template literals. This is a minimal departure from the fix.

check.sh: SUMMARY: 4/4 oracle cases failing (3 fix-added).
