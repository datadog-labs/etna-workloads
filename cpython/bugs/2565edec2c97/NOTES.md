repro.py opens a file via codecs.open with an unknown encoding (LookupError) and prints whether the underlying file was closed. Clean: True; buggy: False (file leaked).
