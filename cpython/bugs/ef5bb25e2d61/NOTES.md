repro.py encodes a whitespace-only header, `Header(' ').encode()`.
Clean prints `' '`; buggy raises IndexError (`_lines` is empty in `newline()`, and the `and self._lines` guard is missing).
