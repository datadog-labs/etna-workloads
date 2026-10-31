# Rationale

Both hunks of the fix still apply to v3.15.2 and were reverted.

1. `Lib/_pyrepl/readline.py`, `maybe_accept.do`: removed the `_newline_before_pos()` helper and the
   `if _newline_before_pos() and text[r.pos:].isspace(): self.finish = True; return` branch.
   This reverses the fix's readline.py hunk. Without it, a second Enter inside a block, with only
   whitespace after the cursor, inserts another newline and auto-indent instead of ending the block.
2. `Lib/_pyrepl/historical_reader.py`, `select_item`: `self.history[i].rstrip()` is back to
   `self.history[i]`. This reverses the fix's historical_reader.py hunk. Recalled history entries
   keep their trailing whitespace again, so the cursor lands after it.

## Oracle cases that fail
- test_reader.TestReader.test_newline_within_block_trailing_whitespace: the block is never
  terminated (`reader.finished` is false, and the screen has extra indented lines).
- test_pyrepl.TestPyReplOutput.test_multiline_edit
- test_pyrepl.TestPyReplOutput.test_history_with_multiline_entries
- test_pyrepl.TestPyReplOutput.test_up_arrow_stays_within_recalled_multiline_entry
