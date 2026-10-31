Casts bytes to '?' format and checks tolist() and equality. Even nonzero bytes (2, 4, ...) should be True; the buggy build treats them as False and compares unequal.
