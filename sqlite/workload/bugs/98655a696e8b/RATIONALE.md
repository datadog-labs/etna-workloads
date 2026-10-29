# Rationale

Hunk reversed: `src/vdbe.c`, `case OP_VRename` (fix hunk in src/vdbe.c).
The fix added `sqlite3VdbeChangeEncoding(pName, SQLITE_UTF8)` before calling
`xRename`, plus the three testcase() lines. In 3.54.1 the same code exists
(with `abort_due_to_error` handling). I removed the testcases and the
conversion/error check, so `xRename` again receives `pName->z` in the
database encoding (UTF16 bytes), as before the fix. The surrounding
LegacyAlter/errmsg/expired logic is unchanged.

Oracle failures: fts3d-6.3 and fts3d-6.5 (rename of an fts3 table in a
UTF16le / UTF16be database yields no renamed shadow tables), and fts3d-6.6
(SQL logic error afterwards).
