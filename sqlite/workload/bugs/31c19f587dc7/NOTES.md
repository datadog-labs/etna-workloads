`format('%.4j','a"b"c')` with a precision: the buggy `if( j<i-1 )` check skips appending the
text between escaped characters when it is exactly one character long.
Clean: `<a\"b\">`; buggy: `<\"\">` (the 'a' and 'b' are dropped).
