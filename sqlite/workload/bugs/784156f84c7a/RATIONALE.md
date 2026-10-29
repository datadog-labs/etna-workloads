# Rationale

Fix hunk (src/resolve.c, lookupName): the rowid fallback tested `HasRowid(pTab)`,
where `pTab` is whatever table the FROM-clause loop looked at last, instead of
the matched table `pMatch->pTab`. The fix switched to `pMatch->pTab`.

In 3.54.1 the check is `VisibleRowid(pMatch->pSTab)`. I reverted it to the last
FROM item's table, `pSrcList->a[pSrcList->nSrc-1].pSTab`. That is the value the
stale `pTab` had after the loop. I did not use `pTab` itself because the
trigger/upsert block now sets `pTab = 0` before this point, so using it would
dereference NULL on every rowid lookup. That would be a different bug.

Oracle failure: `without_rowid1-4.2` (`SELECT t42.rowid FROM t42, t41` with t41
WITHOUT ROWID). The last FROM table is t41, so the rowid check fails. The
`ALWAYS()` wrapper then trips the assertion `lookupName: Assertion '0' failed`.
Without assertions the name would fail to resolve ("no such column").
Case 4.1 still passes, because the last table there is the ordinary t42.
