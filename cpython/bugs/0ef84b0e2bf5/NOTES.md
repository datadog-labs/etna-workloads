repro.py calls warnings.warn with skip_file_prefixes=(__file__,), i.e. a prefix equal to the whole filename.
Clean: the frame is skipped and the warning is attributed to the interpreter (sys) frame, so filename != __file__.
Buggy: PyUnicode_Tailmatch end=-1 drops the last character, so the full-filename prefix doesn't match and the warning is attributed to repro.py.
