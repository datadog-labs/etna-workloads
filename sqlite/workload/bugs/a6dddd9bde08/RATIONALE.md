# Rationale

Fix: `sqlite3AddColumn` added `sqlite3Dequote(zType)` so quoted datatype names
in CREATE TABLE are stored unquoted. In 3.54.1 this is done in two places in
`sqlite3AddColumn` (src/build.c), and both were removed:

1. `sqlite3Dequote(zType)` before `sqlite3AffinityType(zType, pCol)` — the
   direct counterpart of the fix hunk. Removing it alone is not enough:
2. `sqlite3DequoteToken(&sType)` in the standard-typename check. Later code
   dequotes the type token there, so `"INTEGER"` is matched as a standard type
   and the quotes never reach the stored type. This is the same defect on a
   second path; removing it restores the old behaviour where quoted type names
   are kept verbatim.

## Oracle failures
- intpkey-16.0: `id "INTEGER" PRIMARY KEY AUTOINCREMENT` fails with
  "AUTOINCREMENT is only allowed on an INTEGER PRIMARY KEY" (type not recognised as INTEGER).
- intpkey-16.1: consequently table_info returns nothing.
