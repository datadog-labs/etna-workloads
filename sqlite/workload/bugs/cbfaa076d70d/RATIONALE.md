# Rationale

Fix hunk (ext/misc/fileio.c, fsdirBestIndex): the fix made the DIR (old idx5)
constraint count only if usable; before, an unusable `dir=` constraint could be
chosen and given an argvIndex, so join queries like `d JOIN x JOIN fsdir('.', d)`
got a bad plan.

In 3.54.1 the logic was rewritten (idxPath/idxDir, seenPath/seenDir returning
SQLITE_CONSTRAINT). I reverted only the DIR case in `fsdirBestIndex`: `idxDir = i`
is set regardless of `usable`, and the seenDir tracking is removed. This restores
the pre-fix defect (an unusable DIR= constraint used by the plan). The PATH case
is untouched because the pre-fix code already skipped unusable path constraints.

Oracle: test/zipfile.test zipfile-12.5 fails
(`SELECT name FROM d JOIN x JOIN fsdir('.', d)`); everything else passes.
