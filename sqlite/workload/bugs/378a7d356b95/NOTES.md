repro.sql runs `SELECT -'.'` and `SELECT '.'+0`.
Clean shell prints `0` for both. Buggy shell prints `0.0`, because a lone '.' is treated as a float literal with trailing text, so it converts to a real instead of an integer.
