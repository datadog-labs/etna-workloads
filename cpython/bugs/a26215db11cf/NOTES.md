Evaluates the Tcl script `set a "<💻>"` (surrogate-pair escapes) via tkinter.Tcl().eval and prints the result.
Clean: `'<\U0001f4bb>'` (surrogates combined into U+1F4BB). Buggy: `'<\udced\udca0\udcbd\udced\udcb2\udcbb>'` (CESU-8 bytes decoded with surrogateescape, so non-BMP char is mangled).
