Reproducer (`repro.sql`): creates an FTS3 table and runs MATCH queries made of empty phrases (`"" ""`, `"" OR ""`, `"" NOT ""`, `""""`).

Clean shell: no output, exit 0. Buggy shell: aborts on assertion `!pLeft->bDeferred || !pRight->bDeferred` in fts3EvalNextRow (exit -6), because bDeferred is computed wrongly for zero-token phrases.
