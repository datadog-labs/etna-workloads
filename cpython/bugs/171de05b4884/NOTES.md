Opens a directory with wave.open(".", "wb"), which raises OSError inside Wave_write.__init__.
Wave_write.__del__ then runs on the half-built object. A sys.unraisablehook prints any unraisable.
Buggy interpreter: reports an unraisable AttributeError (no `_file`). Clean: just OSError and "done".
