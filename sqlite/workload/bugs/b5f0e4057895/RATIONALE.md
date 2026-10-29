# Rationale

Fix (ticket a08879a4a476eea9): `PRAGMA encoding=` must not change the encoding
if TEMP or any attached database has content; before the fix only the main
database's emptiness was considered.

In 3.54.1 the pragma.c check was rewritten: `PRAGMA encoding=` is allowed only
while `DBFLAG_EncodingFixed` is clear, and that flag is set in
`sqlite3InitCallback` (src/prepare.c) whenever a schema row is read from *any*
database (including temp, via OP_ParseSchema of CREATE TEMP TABLE, or an
attached db). That is the modern equivalent of the fix's loop over all `aDb[i]`.

Change: src/prepare.c, `sqlite3InitCallback`: the flag is now set only when
`iDb==0` (main database). This restores the pre-fix semantics, where only
the main database's state decided whether the encoding could change; content
in TEMP/attached databases is ignored.

Oracle: `enc2-11.10` fails (got mojibake `桴獩椠⁳⁡整瑳` instead of
`this is a test`): the encoding switches to UTF16 after the temp table already
holds UTF8 text. The other 89 cases pass.
