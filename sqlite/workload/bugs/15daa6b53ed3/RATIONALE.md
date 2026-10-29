# Rationale

Most of the fix is already in 3.54.1 (zipfileBegin called lazily from xUpdate,
zipfileNewEntry without data, no in-memory write path). The one hunk that can
be reversed cleanly is in `zipfileAppendEntry` (ext/misc/zipfile.c):

    +    pEntry->iDataOff = pTab->szCurrent;

Removed it. Fix hunk reversed: the added line that records where an entry's
data lands in the archive. Without it iDataOff stays 0, so reading `data` of an
entry written earlier in the same transaction (read back via pWriteFd) reads
from the wrong offset (archive start) instead of the entry's data.

Failing oracle cases: zipfile-8.0.1 (SELECT name, data inside the transaction
returns wrong data) and zipfile-8.0.2 (follow-on). 2 of 146 in test/zipfile.test.
