Calls unicodedata.normalize() with a str subclass instance on already-normalized input
(empty and ASCII) for all four forms, and prints the result type. Clean returns `str`;
buggy returns `MyStr` (the input object is returned as-is).
