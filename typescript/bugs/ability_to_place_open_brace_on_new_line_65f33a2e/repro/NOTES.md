Formats `try { a(); } catch { b(); }` (optionless catch) via the language service's getFormattingEditsForDocument
with placeOpenBraceOnNewLineForControlBlocks = true.
Clean: the `{` after `catch` is moved to a new line (`catch\n{`).
Injected: `catch` was dropped from the control-block open-brace token range, so `catch {` stays on one line.
