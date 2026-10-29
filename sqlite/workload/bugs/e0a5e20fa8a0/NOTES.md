repro.sql: runs three lead() calls (different offsets/default) over one window on a small table.
Clean shell prints the correct rows (4|6|8 ... ||default). Buggy shell aborts with an assertion
failure in sqlite3VdbeExec (lead/lag use pMWin->iEphCsr instead of pWin->iEphCsr, so with multiple
window functions the wrong ephemeral cursor is read).
