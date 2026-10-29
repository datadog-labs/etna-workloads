# Rationale

Fix hunk (src/printf.c, %j/%J): `if( j<i-1 )` -> `if( j<i )` before appending the pending run of unescaped bytes.

In 3.54.1 the line is at src/printf.c:922 (`sqlite3StrAppend64` instead of `sqlite3_str_append`). I restored the condition to `if( j<i-1 )`. A run of length exactly 1 (j==i-1) is then dropped instead of being copied.

Oracle failure: printf-20.25, `format('<%.4j>','a"b"c')`. It returns `<\"\">` instead of `<a\"b\">`, because the single-character runs `a` and `b` are lost.
