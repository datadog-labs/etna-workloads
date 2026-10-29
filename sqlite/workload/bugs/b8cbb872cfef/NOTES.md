The test uses the TCL-only `echo` vtab module, so the reproducer uses the shell's `.expert`, which creates
vtabs whose sqlite3_declare_vtab() schema is `CREATE TABLE x(a COLLATE "NOCASE", ...)`.
With the bug, the declared COLLATE is ignored (IN_DECLARE_VTAB early-return in the collate handler),
so the vtab column has BINARY collation. For `SELECT * FROM t WHERE a='x'` on `t(a COLLATE NOCASE)`:
clean recommends `CREATE INDEX t_idx_00000061 ON t(a)` and a SEARCH plan; buggy prints "(no new indexes)" and SCAN t.
