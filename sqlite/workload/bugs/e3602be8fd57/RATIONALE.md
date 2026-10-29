# Rationale (ticket #3345)

Fix hunk: in `sqlite3FindFunction`, creation condition changed from
`bestScore<6` to `bestScore<6 || pBest->nArg!=nArg`, so that
`sqlite3_create_function(nArg=-1)` does not overwrite an existing function with
nArg>=0. In 3.54.1 that extra condition is already absent, and the case is
covered instead by `matchQuality()`, which returns 0 when `p->nArg>=0` and the
requested nArg differs. So reversing the hunk directly is a no-op. Instead I
restored the pre-fix `matchQuality` semantics, where a requested nArg of -1
means "any" (see the still-present comment `(-1)==any`). This is the same
defect, since the fix existed only to stop a perfect-score match against a
specific-arity function when nArg==-1.

Changes in `src/callback.c` (`matchQuality`):
1. `if( p->nArg>=0 ) return 0;` -> `if( p->nArg>=0 && nArg>=0 ) return 0;`
   (requested -1 no longer rejects fixed-arity functions).
2. `if( p->nArg==nArg )` -> `if( p->nArg==nArg || nArg==(-1) )` (a requested -1
   scores as an exact arity match, so with UTF8 encoding the score reaches
   FUNC_PERFECT_MATCH and the existing FuncDef is reused and overwritten).

The tclsqlite.c `-argcount` hunk is not reverted: 3.54.1 supports it, and
reverting it would only break the test harness.

## Oracle failures
`test/like.test`: like-8.2 and like-8.3 fail. `db function like newlike`
(nArg=-1) overwrites the existing 2-arg and 3-arg LIKE entries instead of
adding a new -1 entry, so the later `-argcount 2` override no longer behaves
as the test expects.
