Parses a file by name (with a deliberately invalid UTF-8 byte) via xml.sax.parse, tracking the file opened by saxutils.
Clean: the source file is closed after the SAXException (`closed: True`). Buggy: it is leaked (`closed: False`).
