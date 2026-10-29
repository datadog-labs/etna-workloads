# Rationale

Fix hunk reversed: `src/build.c`, `sqlite3AddColumn()`. The fix added a block
that strips a trailing "generated always" (the parser can turn those keywords
into identifiers, so they end up in the typename). version-3.54.1 still had
that block verbatim (between `sqlite3DequoteToken(&sName)` and the standard-type
check); I deleted it, restoring the pre-fix code. The fix's other hunks are
manifest files and a test.

Oracle: `gencol1-21.1` fails. Column types for `c`, `d` and `e` come back with
"GENERATED ALWAYS" / "Always" left in the typename instead of `text`, `{}`,
`int`. The other 175 cases pass.
