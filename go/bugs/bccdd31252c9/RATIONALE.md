# Rationale

Fix (#42058): size errors in align.go used the global `lineno` (`yyerror`), which can be stale;
the fix passes `typePos(t)`.

In go1.27.3, `types/size.go` already reports "channel element type too large (>64kB)" with
`base.Errorf` (global `base.Pos`), i.e. the channel line of the fix is already in its pre-fix form.
The bug is masked because the unified-IR reader (`noder/reader.go`, object `do` closure) calls
`setBasePos(pos)` for each declared object, keeping the global position right when types are sized.

Change: removed that `setBasePos(pos)` call in `do` (reader.go ~line 734). This reverts the
"keep the global position correct" path that covers the case, so the error again depends on a
stale global position, as before the fix.

Oracle: `test/fixedbugs/issue42058b.go` fails. The error is printed with no position
("channel element type too large (>64kB)"), so the `// ERROR` on line 9 is reported missing.
issue42058a.go still passes (position happens to be right there).

Caveat: this edit is not a literal reversal of a fix hunk. It is the other path that makes the
global-position approach work, and I judge it the same defect (relying on the global position).
