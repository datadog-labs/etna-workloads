# Rationale
Hunk: `tree/src/services/formatting/rules.ts`, `binaryKeywordOperators` list. I removed `SyntaxKind.SatisfiesKeyword`. This reverses the single hunk of fix.diff, which added it. The code now has one entry per line, so the removal is one line.
Without it, the space-around-binary-keyword-operator rules don't apply to `satisfies`, so formatting drops the space before it after `]`.

Final check.sh line: SUMMARY: 1/1 oracle cases failing (1 fix-added).
