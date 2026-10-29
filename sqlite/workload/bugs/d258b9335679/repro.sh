#!/bin/bash
# Nested "porter" tokenizer arguments recurse once per nesting level in the
# buggy fts5PorterCreate(), blowing the stack. Build a tokenize= string with
# 2^17 "porter" tokens (doubling a 2-token string 17 times).
s="porter Porter"
for i in $(seq 17); do s="$s $s"; done
"$SQLITE3" -batch -init /dev/null :memory: <<SQL
CREATE VIRTUAL TABLE t11 USING fts5(a,b,tokenize="$s");
SELECT 'done';
SQL
exit $?
