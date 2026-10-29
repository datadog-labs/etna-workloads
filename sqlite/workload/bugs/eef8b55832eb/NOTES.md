`repro.sql` runs `select 'abc` (unterminated string literal).
Clean shell: parse error `unrecognized token: "'abc"`, exit 1.
Buggy shell: the tokenizer returns TK_STRING instead of TK_ILLEGAL, so sqlite3Dequote hits assertion `z[i]` and the shell aborts (exit -6).
