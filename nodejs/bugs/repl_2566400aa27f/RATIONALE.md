# Bug
In the REPL, pressing ESCAPE clears the input preview (e.g. `// 2` for `1+1`) and does not bring it back, because the key handler skips `showPreview()` for the escape key.

# Changes
1. `lib/repl.js` (fix hunk 2): the fix calls `showPreview(key.name !== 'escape')` for every key. I restored the old code: `if (key.name !== 'escape') showPreview();`. On ESCAPE the preview is cleared by `clearPreview` and never re-rendered.
2. `lib/internal/repl/utils.js` (fix hunk 1): removed the `showCompletion = true` parameter of `showPreview` and made the completion preview unconditional again, as it was before the fix.

# Failing test
`parallel/test-repl-history-navigation` fails in two consecutive runs (`not ok 1`). The new case (`1+1`, ESCAPE, ENTER) no longer sees the second `\n// 2` preview output after ESCAPE.
