# Rationale

Fix (ticket #3298) made `sqlite3MaterializeView` give the FROM term it builds
the view's name, so a WHERE clause in UPDATE/DELETE on an INSTEAD OF view can
say `v1.x`. Before the fix the view's SELECT was wrapped as an anonymous
subquery with no name/alias.

Change (tree/src/delete.c, `sqlite3MaterializeView`): instead of a FROM term
naming the view (`zName` + schema), duplicate `pView->u.view.pSelect` and
append it via `sqlite3SrcListAppendFromTerm` as a subquery with an empty alias
token (the modern API requires a non-NULL `pAlias`). This is the pre-fix
construction; the view name is unavailable to name resolution.
The fix's signature change (Select* -> Table*) is already in 3.54.1 and
untouched.

Failing oracle cases: tkt3298-1.3 and 1.5 ("no such column: v1.x"), 1.4
(wrong rows deleted; unqualified-name behaviour changes), 2.1 (wrong result).
