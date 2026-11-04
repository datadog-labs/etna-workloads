repro.sql creates a small table and runs upper-case qualified wildcards (`PUBLIC.t1.*`, `T1.*`).
Clean: identifiers are normalized, so all queries return the rows.
Buggy: the qualifier is not normalized, so most of them fail with "Invalid qualifier PUBLIC.t1" / "Invalid qualifier T1". Only the lowercase-qualifier query over `PUBLIC.t1` works.
