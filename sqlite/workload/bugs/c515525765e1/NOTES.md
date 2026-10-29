`repro.sql` binds a parameter used in `a LIKE @p` with `.parameter set`. Binding a value to a LIKE pattern marks the statement expired, so `sqlite3_step` calls `sqlite3Reprepare`.

- Clean shell: prints `abc` and `abd`, exit status 0.
- Buggy shell: aborts with `Assertion 'p->apCsr[i]==0' failed` in `sqlite3VdbeReset`, exit status 134 (reported as -6).

The injected bug makes reprepare swap only the ops (`sqlite3VdbeSwapOps`). The fix swaps the whole Vdbe and transfers the bindings.
