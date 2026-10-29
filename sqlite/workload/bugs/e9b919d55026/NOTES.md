`repro.sql` creates an FTS5 table with `tokenize='trigram case_sensitive'`, which has a dangling option name and no value.

- Clean shell: `Error near line 1: error in tokenizer constructor` (exit 1).
- Buggy shell: it crashes with a segfault (exit -11). The buggy parser reads `azArg[i+1]` past the end of the argument list.
