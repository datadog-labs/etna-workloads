Reads two strings into a ConfigParser(allow_unnamed_section=True) and prints the sections and
the unnamed section's contents. Clean: both keys `a` and `b` are present. Buggy: the second read
recreates the unnamed section, so `a` is lost.
