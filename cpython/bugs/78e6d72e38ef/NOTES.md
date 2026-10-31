repro.py formats SyntaxErrors whose source line contains wide (CJK) characters via traceback.format_exception_only.
The clean interpreter places the caret by display width (`_wlen`); the injected bug uses `len`, so the caret is shifted left by the number of wide characters.
