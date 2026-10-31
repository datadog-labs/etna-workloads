UserDict subclass with `__missing__`: `get()` of a missing key should return None (like dict).
Clean prints `456` then `None`; buggy prints `456` then `456` (MutableMapping.get uses `self[key]`).
