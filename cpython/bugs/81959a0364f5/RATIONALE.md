# Rationale

Hunk changed: `Lib/_pyrepl/commands.py`, `delete.do`. This reverses the fix's only implementation hunk.
The Ctrl+D handling is restored to its pre-fix form: EOFError is raised only when the buffer is empty,
pos is 0 and the key is `\004`. The fix's `if b and b[-1].endswith("\n"): self.finish = True` branch is removed,
so Ctrl+D at the end of a multiline buffer with a trailing newline no longer finishes input.

Failing oracle case: `TestPyReplCtrlD.test_ctrl_d_multiline_with_new_line`. `reader.finished` stays False.
