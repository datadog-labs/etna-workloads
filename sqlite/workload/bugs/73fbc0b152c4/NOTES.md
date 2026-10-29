repro.sql: a table with rowids at the int64 min/max, then rowid lookups using REAL
constants at the boundary (-9223372036854775808.0 and -9223372036854775809.0).
Clean shell returns `min-int` for both (intpkey-18.2/18.3). The buggy shell
returns no rows, because OP_SeekRowid's affinity conversion rejects those reals.
