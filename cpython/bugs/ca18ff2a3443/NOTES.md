repro.py calls _pyrepl.readline._ReadlineWrapper.get_line_buffer() with a stub reader whose get_unicode() returns 'abc'. Clean prints 'abc' (str); buggy prints b'abc' (bytes).
