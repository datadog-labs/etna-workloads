Reproducer (`repro.sh`): a temp trigger on main.t1 is created, `aux` is attached, and a second
process creates a table `t1` in aux's file, then `INSERT INTO aux.t1` reloads aux's schema. Next,
`INSERT INTO main.t1` fires the temp trigger (raise(ABORT)).

Clean: prints `Error near line 6: error`, exit 1.
Buggy: temp triggers get linked into the wrong table's trigger list on schema reload, so the
shell loops forever (killed by the `timeout 10`).
