Binds an AF_ALG socket to names exactly at the limit (type of 14 chars, name of 64 chars; the fields are 14 and 64 bytes and must be NUL-terminated).
Clean: those lengths raise ValueError ("type too long" / "name too long"). Buggy: the check is off by one (`>` instead of `>=`), so they fall through to bind() and raise FileNotFoundError.
