`repro.sql` creates table b(id) containing a NULL and a DESC index on b(id), then runs `id NOT IN (SELECT id FROM b)`.

With the bug, the NULL-detection code scans the DESC index from the start (Rewind) instead of the end (Last). It misses the NULL, which sorts last in a DESC index.

- Clean shell: the NOT IN query returns no rows, and `1 IN (...)` is NULL, as SQL requires.
- Buggy shell: the NOT IN query returns rows 1 and 2, and `1 IN (...)` returns 0 instead of NULL.
