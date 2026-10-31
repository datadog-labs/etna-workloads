`repro.py` registers a fake digest name 'foo' in `hashlib.__builtin_constructor_cache` (mapped to sha256) and calls `hmac.digest(b'key', b'message', 'foo')`. This is the body of `test_with_fallback`.

Clean: OpenSSL raises the module's `UnsupportedDigestmodError`, which `hmac` catches before falling back to the builtin constructor. It prints the sha256 HMAC hex digest.
Buggy: `raise_unsupported_str_algorithm_error` raises a plain `ValueError`, so `hmac` doesn't fall back. It prints `ValueError ... unsupported hash algorithm foo`.
