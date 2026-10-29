repro.sql runs REGEXP on strings containing code points 0x800, 0xfff, 0x10000 and 0x10ffff, each matched against a pattern made of that same character (the cases from regexp1-7.x).
Clean shell prints 1 for each query. Buggy shell prints 0 for each: the regexp.c initial-prefix optimization and the 4-byte UTF-8 bounds check were broken by the injected patch.
