# Rationale

The fix made `isSelfJoinView()` also compare `pHaving`, so a view whose HAVING
was changed by push-down is not treated as the same as an unmodified copy. In
3.54.1 that check was replaced by the `SF_PushDown` flag, which covers WHERE and
HAVING. I restored the pre-fix test, which compares only WHERE, in
`src/select.c` `isSelfJoinView()`:

1. The per-item check `if( pS1->selFlags & SF_PushDown )` is now
   `if( sqlite3ExprCompare(0, pSel->pWhere, pS1->pWhere, -1) )`. This is the
   pre-fix WHERE-only comparison, and it never looks at HAVING. It reverses
   the fix hunk's added `pHaving` comparison, in the form the code takes today.
2. The early `if( pSel->selFlags & SF_PushDown ) return 0;` is removed. It is
   a later addition that guards the same case from the other side, so the
   pre-fix code did not have it. Without removing it,
   `fromClauseTermCanBeCoroutine` would still make the pushed-down copy a
   coroutine, and the bug would not show.

Result: `SELECT * FROM v16 AS one, v16 AS two WHERE one.mx=1` pushes `mx=1`
into the HAVING of `one` only. The two aliases are still judged identical, so
`two` reuses `one`'s filtered materialization.

Failing oracle case: `view-26.0` (wrong result for the self-join of the
aggregate view). The other 122 cases still pass.
