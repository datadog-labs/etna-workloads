# Rationale

Fix: gh-128067, pyrepl wrote a "\n" on the first refresh, which overwrote output that had no trailing newline.

The fix's `clear()` hunk (`self.screen = [""]` -> `[]`) has no equivalent to reverse. `clear()` now calls `sync_rendered_screen(RenderedScreen.empty(), ...)`, and the empty screen is already `()`. It was left unchanged.

- `Lib/_pyrepl/unix_console.py`, grow-lines loop in the refresh apply step: removed the `if screen_line_count:` guard. This reverses the `if self.screen:` hunk. `screen_line_count` is the refactored `len(self.screen)`. The move-up and "\n" now run even when the screen is empty.
- `Lib/_pyrepl/windows_console.py`: same change, with `_move_relative`.

Oracle: `test_unix_console.TestConsole.test_no_newline` fails. Typing "1" emits a stray `\n` (preceded by a cursor-up escape) on the first refresh. This is the symptom the fix guards against.
