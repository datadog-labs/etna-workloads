repro.sql calls split_part with an empty delimiter, on constants and on VALUES columns, using positions 1, -1, 2 and -2.
Clean build (PostgreSQL semantics): the whole string is one field, so 1 and -1 return 'a,b' and 2 and -2 return an empty string.
Buggy build: Rust's split("") yields leading and trailing empty fields, so 1 returns '' and 2 returns 'a', and the negative positions are likewise wrong.
