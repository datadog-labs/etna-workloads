repro.sql inserts text containing U+FFFF / U+FFFE into an fts5 table (default unicode61 tokenizer) and lists the terms via fts5vocab.

Clean shell: U+FFFE/U+FFFF are separators, so terms are abc, def, ghi, jkl.
Buggy shell: they are treated as token characters, giving terms `abc<U+FFFF>def` and `ghi<U+FFFE>jkl`.
