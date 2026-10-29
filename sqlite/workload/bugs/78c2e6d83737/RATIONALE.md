# Rationale

Fix (ticket #3590) added RELEASE and SAVEPOINT to the `%fallback ID` list in
src/parse.y so these keywords can still be used as identifiers.

Change: in `tree/src/parse.y`, removed `RELEASE` and `SAVEPOINT` from the
`%fallback ID` token list. This is the exact reverse of the fix hunk; the list
has only grown since 2009 (the fix's two-line list is now lines 277-278), so
the change is the same defect.

Oracle failures: `table-7.3` (CREATE TABLE savepoint(release) is a syntax
error) and `table-19.1` (the `savepoint` table was never created, so the table
listing lacks it).
