repro.sql runs `SELECT COUNT(t.*) FROM t` (qualified wildcard in count).
Clean: returns 3. Buggy: "This feature is not implemented: Physical plan does not support logical expression Wildcard {...}".
The `COUNT(foo.*)` invalid-qualifier error is the same in both builds.
