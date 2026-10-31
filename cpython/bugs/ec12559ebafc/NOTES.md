Reproducer: `json.dumps({b'invalid_key': False}, skipkeys=True, indent=4)`, via the C encoder (`dumps`) and the pure-Python encoder (`iterencode` with `_one_shot=False`).

Clean: `'{}'` for both. Buggy: `'{\n    \n}'` for both. The buggy build emits the opening newline+indent even when every key is skipped.
