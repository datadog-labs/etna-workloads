The upstream test uses a TCL-defined virtual table, which the shell lacks. `repro.sql` instead uses the built-in `generate_series` virtual table. It joins three of them to the right of a CROSS JOIN, with equality constraints between them.

- clean: prints the two result rows and exits 0.
- buggy: aborts with `Assertion '(mUsable & mPrereq)==mPrereq' failed` in `whereLoopAddVirtualOne` and exits 134.

The injected bug drops `|mPrereq` from the `mNext` argument passed to `whereLoopAddVirtualOne`.
