# Rationale

Hunk changed: `Lib/plistlib.py`, `_PlistWriter.write_bytes` (line 398).

Fix hunk reversed: the fix replaced
`len(self.indent.replace(b"\t", b" " * 8) * self._indent_level)` with
`len((self.indent * self._indent_level).expandtabs())`. In v3.15.2 the code was
already restructured (`wrapcol` variable) but used the fixed expression; I restored
the old computation, which expands every tab to 8 columns instead of advancing to
the next tab stop, so mixed tab/space indents give the wrong line width.

Oracle: `test_plistlib.TestPlistlib.test_bytes_indent` fails (the `b' \t'` indent
case wraps at the wrong column).
