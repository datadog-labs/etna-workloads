`repro.sql` calls `jsonb_insert('{"a":2,"c":4}', '$.a', 99)` and prints the result through `json()`.

- Clean shell: `{"a":2,"c":4}`. Insert doesn't overwrite an existing key.
- Buggy shell: `{"a":99,"c":4}`. `jsonb_insert()` behaves like `jsonb_set()`.

This is the case json102-320-3 in `test/json102.test`.
