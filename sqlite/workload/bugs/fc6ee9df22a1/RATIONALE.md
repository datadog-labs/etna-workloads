# Rationale

Fix hunk reversed: `src/printf.c`, `case etCHARX` in `sqlite3VXPrintf`. The fix changed the SQL `printf()` (bArgList) path from `c = getIntArg(pArgList)` to reading the first character of the text argument via `getTextArg`.

In 3.54.1 that branch had grown into UTF-8-aware code. I replaced the bArgList branch with `ch = (unsigned int)getIntArg(pArgList); length = sqlite3AppendOneUtf8Character(buf, ch);`. This is the same computation the non-arglist branch uses, applied to the integer value of the argument. That matches the pre-fix `c = getIntArg(...)`. `%c` therefore treats its SQL argument as a code point rather than a string.

The `etSIZE` brace hunk is cosmetic, so I left it alone.

Oracle failures: printf2-1.13 (`printf('%c','abcdefghijklmnop')` gives a NUL character instead of `a`). Several other cases that use `%c` with text arguments also fail (printf2-3.1 to 3.5, printf2-5.100 to 5.106).
