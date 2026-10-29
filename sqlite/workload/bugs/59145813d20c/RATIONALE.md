# Rationale

Fix hunk reversed: the `if( pWalker->eCode ){ p->selId = ++pParse->nSelect; }`
block at the top of `selectExpander()` in `src/select.c`. I removed it.
Without it, the Select copies made when a VIEW is expanded keep the selId of
the original view definition. When the same view is used twice in one join,
both expansions share a selId.

The other fix hunks (setting `pWalker->eCode = 1` around the walk of the view
copy, and `w.eCode = 0` in `sqlite3SelectExpand`) are left in place. They are
now harmless: they only feed the removed check. `eCode` is also used elsewhere
with the same Walker.

Oracle: `with1-23.1` (the ticket's test) fails with
`Assertion 'p2<(u32)pC->nField ...' failed` in `sqlite3VdbeExec`. This is the
wrong-code symptom for a view that is expanded twice. The other with1 cases pass.
