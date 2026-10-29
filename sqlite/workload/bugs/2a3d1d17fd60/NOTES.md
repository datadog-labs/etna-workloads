`repro.sql` runs `SELECT 1 IS #1;`. `#1` is an illegal "#ID" variable, so the parser gets a NULL right-hand expression.
Clean shell: `Parse error ... syntax error`, exit 1.
Buggy shell: segfault (exit 139), because injection.patch removes the NULL check on `pRight` in the IS operator rule.
