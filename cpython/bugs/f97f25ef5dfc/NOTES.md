Parses an 8bit iso-8859-1 message declared as us-ascii and calls as_string().
Clean: returns the text with non-ASCII bytes replaced by U+FFFD.
Buggy: set_payload encodes without surrogateescape (and the generator passes the
wrong payload), so as_string() raises UnicodeEncodeError.
