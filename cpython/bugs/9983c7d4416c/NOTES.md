repro.py builds a tar with a member name that decodes to a lone surrogate ('\ud800'), then calls extractall() with errorlevel=1 and errorlevel=0.
Clean: errorlevel=0 treats the UnicodeEncodeError like an OSError. It prints "tarfile: UnicodeEncodeError ..." and extractall() returns normally.
Buggy: the UnicodeEncodeError escapes extractall() even with errorlevel=0.
