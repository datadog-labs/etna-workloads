# Rationale

In v3.15.2 the `multiline_block` attribute and its setting in `read_command` already exist
(via `read_input`), so only the `complete()` hunk of the fix needed reverting.

Changed `PdbClient.complete` in `Lib/pdb.py`. Fix hunk reversed: the last hunk, which added the
`if self.multiline_block: line = "! " + line` prefix and renamed `stripped` to `offset`. The code
now computes `begidx`/`endidx` from the lstrip amount only, as before the fix. Continuation lines
of a multi-line block are therefore sent to the remote without the `!` prefix, so the remote may
treat them as pdb commands instead of Python expressions.

Failing oracle case: `PdbClientTestCase.test_multiline_completion_in_pdb_state`. It expects
`line: "! b", begidx: 2, endidx: 3` and gets `line: "b", begidx: 0, endidx: 1`.
