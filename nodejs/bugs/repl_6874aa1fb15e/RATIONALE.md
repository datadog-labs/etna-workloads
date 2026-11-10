# Rationale
Bug: the REPL `.load` command split the file on newlines and wrote each non-empty line separately (`this.write(line + '\n')`), dropping blank lines, instead of passing the whole file content to `this.write(data)`. Blank lines in loaded files (and multi-line input structure) were lost/altered.

Hunk (lib/repl.js, `load` action): corresponds to the fix hunk replacing the split/for loop with `this.write(data)`. Re-expressed for today's code (primordials `StringPrototypeSplit`, import added to the primordials destructure). Restores the old line-by-line, skip-empty-lines behavior.
(The save/message-format hunks of the fix are cosmetic/test-related in today's code and not reverted.)

Failing test: parallel/test-repl-load-multiline — output no longer contains the blank line between `.then(eat);` and `const placeOrder...`, so the expected-output assertion fails.
