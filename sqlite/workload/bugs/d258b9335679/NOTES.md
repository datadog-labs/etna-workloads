# NOTES

`repro.sh` creates an FTS5 virtual table whose `tokenize=` option nests a
large number of `porter` tokenizer arguments (built by doubling a 2-token
string 17 times, giving 2^17 "porter"/"Porter" tokens), e.g.:

```sql
CREATE VIRTUAL TABLE t11 USING fts5(a,b,tokenize="porter Porter porter Porter ... (2^17 times)");
```

This mirrors `fts5tokenizer.test` case 11.1, added by the fix for bug report
a7766198f1.

`fts5PorterCreate()` previously only stripped a single leading tokenizer
name from `azArg` and otherwise passed the whole argument list straight
through to create the "base" tokenizer, so each `porter` argument in the
list causes another recursive call to create a nested porter tokenizer.
With enough nesting levels this exhausts the stack.

- **clean** (`bin/sqlite3-clean`): the fix loops over and discards every
  leading `porter`/`Porter` argument before picking the base tokenizer, so
  the statement runs fine and prints `done`, exit status 0.
- **buggy** (`bin/sqlite3-buggy`, `injection.patch` applied): the recursive
  nested-tokenizer creation blows the stack, crashing with SIGSEGV (exit
  status 139) before printing `done`.
