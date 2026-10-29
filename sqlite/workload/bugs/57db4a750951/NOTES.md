Inserts '2.5e2147483650' and '2.5e-2147483650' into a REAL column. The exponent
accumulator in sqlite3AtoF overflows 32-bit int in the buggy build, so the
results are wrong (not Inf and 0.0 as in the clean shell).
