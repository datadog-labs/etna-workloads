repro.py tokenizes a multiline f-string containing non-ASCII characters (🔗) and an
expression, then prints each token's type, string, start and end.

Clean: the trailing FSTRING_MIDDLE '🔗\n🔗' starts at (2, 32).
Buggy: it starts at (2, 35), because the byte-to-character column offset diff isn't
recomputed correctly for multiline tokens. Exit status is 0 for both.
