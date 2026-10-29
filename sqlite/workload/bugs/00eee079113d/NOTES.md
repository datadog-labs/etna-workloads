With defensive mode and trusted_schema=OFF, a view using LIKE is queried after `PRAGMA case_sensitive_like=ON`.
Clean: returns `1|abc`. Buggy: `Parse error: unsafe use of LIKE()`, because re-registering LIKE leaves SQLITE_FUNC_UNSAFE set.
