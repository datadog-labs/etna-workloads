# Re-introduced bug: REPL preview shown after pressing Escape

**Bug.** In the REPL, pressing Escape cleared the preview but the key handler then called `showPreview()` again, so the input preview (e.g. `// n`) reappeared after Escape.

**Hunk (lib/repl.js, non-editor-mode key handler).** The fix wrapped `showPreview()` in `if (key.name !== 'escape')`. In v26.13.0 this had been re-expressed as `const showCompletionPreview = key.name !== 'escape'; showPreview(showCompletionPreview);`. That flag only suppresses the completion preview, so the input preview is still shown after Escape. I replaced those two lines with an unconditional `showPreview();`, which is the pre-fix behaviour.

**Failing test.** `parallel/test-repl-history-navigation` fails on every run (3 runs). It reports `AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal`. The ESCAPE step emits extra preview output (`' // n', '\x1B[10G'`) that the test does not expect.
