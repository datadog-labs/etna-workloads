Formats a colorized SyntaxError whose source line contains CTRL-Z (`"a\x1a$"`).
CTRL-Z has display width 2, so the caret line should be indented 3 columns.
Clean: 3 spaces before the caret. Buggy: 2 spaces (the ASCII fast path in `_display_width` counts raw characters), so the caret is misaligned.
