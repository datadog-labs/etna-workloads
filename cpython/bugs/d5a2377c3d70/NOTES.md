Sets a SimpleCookie value and a Comment attribute containing a non-ASCII character, then prints the Set-Cookie header.
Clean: `Set-Cookie: foo="\251"; Comment="comment \251"` (Comment is quoted).
Buggy: Comment is emitted unquoted/raw (`Comment=comment ©`).
