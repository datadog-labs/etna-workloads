Hunk: tree/src/compiler/transformers/esDecorators.ts, visitConstructorDeclaration, no-super `else` branch.
Corresponds to fix.diff's hunk, whose `else` branch (no super call) emitted initializers then the body once.
The pre-fix code, with no super, visited the body statements both before and after the initializers (double emit).
Reintroduced by visiting the body before the initializers and again after them when no super statement is found.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
