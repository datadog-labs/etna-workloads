repro.sh: connection A loads the schema, then runs `select * from t3` while connection B holds an
exclusive lock and creates t4 (A waits in the busy handler). When B commits, A's OP_VerifyCookie
sees a changed schema cookie.
Clean: the statement is re-prepared and returns `1|2`, then lists t3 and t4.
Buggy: the schema isn't reset or the statements expired, so A gets "database schema has changed" on
that and on later statements.
Timing uses sleeps (1-2s) but is deterministic in practice.
