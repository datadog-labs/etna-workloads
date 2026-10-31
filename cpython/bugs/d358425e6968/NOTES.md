Uses the pure-Python JSON scanner (py_make_scanner) to decode "1０", "0.０", "0e０" (fullwidth digits).
Clean: raises JSONDecodeError for each. Buggy: the regex uses \d, which accepts non-ASCII digits, so they decode to numbers (e.g. 10, 0.0).
