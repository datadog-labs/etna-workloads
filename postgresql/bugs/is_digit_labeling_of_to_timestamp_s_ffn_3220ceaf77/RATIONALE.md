# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3220ceaf774a2a11f86b33425d836e7072aed677 ("Fix is_digit labeling of to_timestamp's FFn format codes."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/formatting.c

Failing oracle cases:
- `src/test/regress||horology`
