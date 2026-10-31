repro.py: urlopen() on data: URLs with a control character in the mediatype. Clean raises ValueError; buggy (control-char check removed) returns the data.
