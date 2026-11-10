# Re-introduced bug: no preview for input lines longer than the terminal width

Before upstream fix ca9f12bf, the REPL input preview was suppressed whenever the
current line plus prompt exceeded `repl.columns`, because preview cursor
positioning could not handle wrapped lines. The fix removed that guard (and made
the positioning wrap-aware).

## Change (lib/internal/repl/utils.js, `showPreview`)
- Corresponds to the fix hunk deleting the "Do not show previews in case the
  current line is longer than the column width" early return. Re-added it
  (using `repl.getPrompt().length`, as today's code has no `_prompt`).
- The fix's other hunks (getPreviewPos / clearPreview / write positioning) are
  already wrap-aware in the release in a different form; they are unreachable
  once the guard returns early, so no change was needed there.

## Failing test
parallel/test-repl-history-navigation: not ok. The long-line cases
(`veryLongName` x30, 360 chars > 250 columns) no longer produce the
"I should be previewed" preview, so the expected output differs.
parallel/test-repl-preview still passes.
