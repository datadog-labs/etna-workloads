# Rationale

Fix (2018-06-23): `pushDownWhereTerms()` returned 0 early when the sub-query had window functions (`if( pSubq->pWin ) return 0;`, restriction 6). Without it, an outer WHERE term such as `rank<=2` was pushed into a window sub-query and filtered rows before the window function was computed.

In 3.54.1 that blanket check was replaced by finer-grained restrictions, so the fix hunk can't be reversed directly. Two spots in `src/select.c` cover the same case, and I disabled both:

1. `pSubq->pWin && pSubq->pWin->pPartition==0` early return (non-compound branch). Removed. Without it, sub-queries whose window has no PARTITION BY accept pushed-down terms again.
2. `pushDownWindowCheck()` call in the push-down loop (restriction 6c). Replaced with `if( 0 )`. Terms that aren't PARTITION BY expressions are now pushed down, as in the pre-fix code, which had no check.

Both are the same defect: pushing WHERE terms into a window-function sub-query. I left the compound-select check (6b) alone.

## Oracle
`window1-10.1` fails. The outer `rank<=2` term is pushed down into the `row_number()` sub-query, so row_number is computed over already-filtered rows and the wrong rows come back. The other 348 cases pass.
