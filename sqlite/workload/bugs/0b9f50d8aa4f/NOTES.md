repro.sql: AUTOINCREMENT table with BEFORE/AFTER INSERT triggers that insert into
the same table (upstream test autoinc-3928).
Clean shell: sqlite_sequence has a single row `t|13`.
Buggy shell: the per-table AutoincInfo sharing is disabled, so extra duplicate
sqlite_sequence rows are created (t|12, t|13, t|10, t|11, t|7).
