`repro.sql` stores '日本語' (3-byte UTF-8 characters) in a table and runs `WHERE a REGEXP '日本語'` (the shell has the regexp extension built in).
The regexp prefix optimization encodes 3-byte characters with the wrong lead byte (0xd0 instead of 0xe0) in the buggy shell.
The clean shell returns `1|日本語`. The buggy shell returns no rows.
