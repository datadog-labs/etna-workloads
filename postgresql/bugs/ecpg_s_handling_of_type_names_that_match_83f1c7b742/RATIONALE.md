# Rationale

Hunk: src/interfaces/ecpg/preproc/pgc.l, rule `{identifier}` (C/SQL lexer).
Traces to the fix.patch pgc.l hunk. The fix only looks up SQL/ECPG keywords if
`get_typedef(yytext, true) == NULL`, so user typedefs override SQL keywords. I removed
that guard, so a typedef whose name matches an SQL keyword is lexed as a keyword and
the parser fails on it, which is the bug the fix removed.

Failing oracle case: src/interfaces/ecpg||preproc/type (expected; see the oracle run).
