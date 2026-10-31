# Rationale

Only one hunk of the fix is still reversible in v3.15.2 (the .pdbrc queue
handling in `setup`, `interaction` and `handle_command_def` was already
rewritten). The change is in `Lib/pdb.py`, `Pdb.precmd`:

    self.cmdqueue.insert(0, next)  ->  self.cmdqueue.append(next)

This reverses the fix hunk in `precmd`. The text after a `;;` separator is
queued behind everything already in `cmdqueue` instead of in front of it. When
.pdbrc (or `-c`) preloads several lines into `cmdqueue`, the rest of a
`;;`-split line runs after the later rc lines, so the commands execute out of order.

Oracle cases that fail (3 failures in test.test_pdb): the .pdbrc semicolon/commands
tests (e.g. `test_pdbrc_commands`, where `commands 1 ;; p a;; end` followed by `c`
runs `c` before `p a;; end`), plus a doctest that checks `;;` ordering.
