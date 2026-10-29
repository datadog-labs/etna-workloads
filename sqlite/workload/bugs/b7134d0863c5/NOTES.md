Reproducer: `CREATE VIRTUAL TABLE t3 USING fts4(tokenize=);` (empty tokenizer declaration).
Clean shell: error "unknown tokenizer: ". Buggy shell: sqlite3Fts3NextToken returns NULL and the
code does `z[n]=0` on NULL, so it crashes / fails an assertion.
