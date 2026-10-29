`repro.sql` runs `json_tree('{"\u0017":1}', '$."\x17"')` (json502-4.1).

The first-row `path` computation in `jsonEachPathLength` mishandles escape sequences in the path argument.
- Clean shell: returns the row `\x17|1|integer|1|1||$."\x17"|$`.
- Buggy shell: aborts with `Assertion 'sz<n' failed` in `jsonEachPathLength` (exit status -6).
