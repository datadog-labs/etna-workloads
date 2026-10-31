Creates a sqlite3.Row from a cursor whose `description` is None, then calls `row.keys()` and `row["nokey"]`.
Clean: `[]` and `IndexError: No item with key 'nokey'`.
Buggy: PyTuple_Size(None) leaves a SystemError set, and keys() aborts with "a function returned a result with an exception set".
