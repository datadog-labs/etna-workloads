Creates an empty MH mailbox directory and calls `lock()`/`unlock()` when no `.mh_sequences` file exists.
Clean: succeeds and creates `.mh_sequences` (listdir -> `['.mh_sequences']`).
Buggy: `lock()` opens with `rb+` and raises FileNotFoundError; directory stays empty.
