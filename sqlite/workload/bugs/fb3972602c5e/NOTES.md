repro.sql runs the like-13.x cases: LIKE between a non-ASCII character and another character whose low 8 bits match case-insensitively (U+304D vs U+306D, U+004D vs U+306D, U+304D vs U+006D).
Clean shell prints 0,0,0,1. The buggy shell lowercases only the low 8 bits, so the first three return 1.
