# Rationale

File: src/backend/access/gin/gindatapage.c, function createPostingTree().
Traces to the single fix.patch hunk set in that function: the fix builds the root page in a palloc'd temp page
(before the critical section), then gets the buffer and copies it in with PageRestoreTempPage inside the critical section.
Reverted: the buffer is obtained first, START_CRIT_SECTION() is entered, and the page is initialised and filled directly,
so ginCompressPostingList() (which palloc's) and pfree run inside the critical section again. The temp page is removed.
Palloc in a critical section triggers an assertion/error (e.g. under memory-context checks) during GIN posting tree creation.

Oracle case expected to fail: src/test/regress||create_index
