Calls `email.quoprimime.decode` with `eol='\r\n'` on input lacking a trailing newline.
Clean: `'abc'` and `'a\r\nb'`. Buggy: strips only one char (`decoded[:-1]`), leaving a stray `\r` (`'abc\r'`, `'a\r\nb\r'`).
