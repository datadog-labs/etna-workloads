repro.py: HTTPResponse with Content-Length; after read1()/readline() consume all data, isclosed() should be True (clean) but is False (buggy).
