Creates a table whose DEFAULT values are followed by comments, then runs PRAGMA table_info.
Clean shell prints the default values only ('abc', -1, +4.0). The buggy shell includes the trailing comment text in the dflt_value column.
