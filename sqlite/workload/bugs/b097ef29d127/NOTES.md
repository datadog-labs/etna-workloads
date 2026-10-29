Runs the three substr() cases from func-2.11..2.13 (64-bit 2nd/3rd args).
Buggy shell truncates the args to 32 bits, so the results differ
(e.g. substr('abcdefg',0x100000001,2) returns 'ab' instead of '').
