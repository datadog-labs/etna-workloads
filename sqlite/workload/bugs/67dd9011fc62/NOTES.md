Reproducer for ticket #1912: a numeric literal directly followed by identifier characters.
`SELECT 123abc;` and `SELECT 1*123.4e5ghi;` should fail with `unrecognized token`.
The buggy shell lacks the check, so it tokenizes them differently (different error/result than clean).
