repro.py calls `tkinter._join` on strings containing Tcl-special characters (`{`, `}`, `\`, leading `"`, newline) and prints the joined string plus what Tcl's `lindex` returns for the first element.

The buggy build no longer escapes newlines or a leading `"`, and wraps single-element lists wrongly. For example `'{sp\nam}'` comes back as `'{sp am}'`, and `'"{spam}"'` as `'{spam}'`. The clean build round-trips every value.
