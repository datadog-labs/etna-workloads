# Rationale

**Bug:** The REPL preview's cursor restore was computed relatively: after writing the preview, the cursor was moved by `cursorPos.cols - resultCols`. When the preview was exactly as wide as the terminal, the cursor wrapped and ended up in the wrong column.

**Hunk (lib/internal/repl/utils.js, preview writer in `setupPreview`):** This corresponds to the single implementation hunk of the fix. I re-added `const { cols: resultCols } = repl._getDisplayPos(result);` before the write. I replaced `cursorTo(repl.output, cursorPos.cols); moveCursor(repl.output, 0, -rows - 1);` with `moveCursor(repl.output, cursorPos.cols - resultCols, -rows - 1);`. This is the pre-fix relative move. The surrounding comments differ from the original because the code has changed since the fix.

**Failing tests** (after `make`, which succeeded): test-repl-preview, test-repl-history-navigation and test-repl-reverse-search all report `not ok`. The expected escape sequences, such as `\x1B[11G`, no longer match the relative moves, such as `\x1B[5D`. I did not run the suite a second time to confirm the failures are stable.
