Parses a message with Content-Type multipart/mixed but a plain string body, then lists iter_attachments().
Clean: prints `[]`. Buggy: AttributeError ('str' object has no attribute 'copy') since payload.copy() is unguarded.
