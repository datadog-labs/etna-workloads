Creates a zip file with one entry, then in a new connection deletes that only entry
(DELETE ... WHERE 9) and inserts a new one inside a savepoint.
Clean: prints `done`, exit 0. Buggy: assertion failure in zipfileAddEntry
(`(pFirstEntry==0)==(pLastEntry==0)`), abort, exit 134, because removing the last
list entry leaves pLastEntry dangling.
