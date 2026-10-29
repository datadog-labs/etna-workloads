Compares 'abcde' and 'abcd' under COLLATE RTRIM. The buggy allSpaces() returns true
for a single-char non-space tail (it checks n==0 after the decrement), so the strings
compare equal (1, 1). The clean shell returns 0, 0.
