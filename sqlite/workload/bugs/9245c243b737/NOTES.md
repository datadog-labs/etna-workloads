Runs `SELECT ... GROUP BY ORDER BY log` and `SELECT ... GROUP BY;` (empty GROUP BY).
Clean shell: `near "ORDER": syntax error` / `near ";": syntax error`.
Buggy shell: the empty GROUP BY is accepted and the statements run without error (no output).
