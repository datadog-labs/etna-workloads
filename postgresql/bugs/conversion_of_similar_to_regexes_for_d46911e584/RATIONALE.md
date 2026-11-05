# Rationale
File: src/backend/utils/adt/regexp.c, function similar_escape_internal (hunk "else if (bracket_depth > 0)" branch).
Traces to the fix.patch hunk that changed `if (pchar == ']') incharclass = false;` into
`if (pchar == ']' && charclass_start > 2) charclass_depth--`. In current code the equivalent
guard is `pchar == ']' && charclass_pos > 2`; I removed the guard, so a ']' at the start of a class
(`[]a]`, `[^]a]`) closes the class instead of being literal, as before the fix.

Failing oracle case: src/test/regress||strings
