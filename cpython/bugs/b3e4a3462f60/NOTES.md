Mocks `Helper.getline` to feed "", "    ", "quit" into `pydoc.Helper.interact()`.
Clean: empty/blank lines re-prompt, session ends at "quit" and the transcript is printed.
Buggy: the empty line ends the session, so the output has only one prompt (and the blank-only line is never read).
