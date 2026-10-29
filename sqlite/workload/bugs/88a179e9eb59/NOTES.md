Creates an fts3 table with 4 columns and calls snippet() with an out-of-range
column index (4, and 4294967299 which wraps to 3 as a 32-bit int).
Clean shell returns empty strings; the buggy shell returns "one two three A"
and "one {two} three D" instead.
