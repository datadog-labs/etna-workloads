# Rationale

Fix: introduced `Fts3Table.bFts4` and replaced uses of `bHasStat` (which is also
set to 1 on an FTS3 table once incrmerge/automerge creates a %_stat table) as
the "is FTS4" test. Re-injected by reverting these uses back to `bHasStat`:

- fts3_write.c `sqlite3Fts3UpdateMethod`: `if( p->bFts4 )` -> `bHasStat` for fts3UpdateDocTotals (fix hunk @5347).
- fts3_write.c `fts3DoRebuild`: same (hunk @3302).
- fts3.c `fts3FilterMethod`: bFts4 arg to sqlite3Fts3ExprParse -> `bHasStat` (hunk @2974), so FTS3 tables with a stat table accept FTS4-only syntax.
- fts3.c `fts3EvalStart`: deferred-token check uses `bHasStat` (hunk @4385).
- fts3_snippet.c `fts3MatchinfoCheck`: NDOC/AVGLENGTH use `bHasStat` (hunk @794).
- fts3_write.c: removed the two `assert( p->bFts4==0 )` added by the fix in fts3DoIncrmerge/fts3DoAutoincrmerge (they didn't exist pre-fix).

The `p->bFts4` field and its other asserts are left in place (harmless).

## Oracle
test/fts4merge.test: the fts3 variants fail (814/818 cases); run aborts with
`sqlite3Fts3MsrOvfl: Assertion p->bFts4 failed` (the assert, from the fix, is
retained and catches an FTS3 table treated as FTS4 after incrmerge created a stat table).
