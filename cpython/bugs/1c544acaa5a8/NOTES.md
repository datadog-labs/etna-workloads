Registers a handler whose methods are named `open`, `_open` and `error` (no protocol prefix) on an OpenerDirector and prints the keys of `handle_open`/`handle_error`.
Clean: `[] []`. Buggy: bogus protocols `''` and `'ope'` / `'erro'` get registered (`['', 'ope'] ['erro']`), because the `i < 1` check in `add_handler` is missing.
