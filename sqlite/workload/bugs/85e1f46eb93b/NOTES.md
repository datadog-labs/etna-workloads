Creates a table with a usable index p1 and an unusable partial index p2 (WHERE z=1), then runs
`SELECT * FROM o1 INDEXED BY p2 ORDER BY 1`. Clean shell: "Error: no query solution".
Buggy shell: the unusable-index skip no longer ends the loop, so another index (p1) is considered and the query runs (no error).
