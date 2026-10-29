# Rationale

Fix (ticket #1650) made sqlite3_prepare() honor nBytes by parsing a private
NUL-terminated copy (sqlite3StrNDup) of the first nBytes bytes when zSql is
not already terminated there, then translating zTail back into the caller's buffer.

In 3.54.1 this lives in `sqlite3Prepare()` in `src/prepare.c`. I removed the
`sqlite3DbStrNDup` copy, the `sqlite3RunParser(&sParse, zSqlCopy)` call, the
zTail rebasing and the free; the non-NUL-terminated branch now parses `zSql`
directly, exactly the pre-fix `sqlite3RunParser(&sParse, zSql)`, so text past
nBytes is parsed. The SQLITE_TOOBIG check is a later, separate feature and was left alone.

## Oracle failures (test/capi3.test)
capi3-15.2, 15.4-15.8 (statement prepared with nBytes covering only
"SELECT * FROM t2" is executed with the trailing " WHERE a==1", and tail is
wrong), and capi3-19.1 (tail/ptr result differs).
