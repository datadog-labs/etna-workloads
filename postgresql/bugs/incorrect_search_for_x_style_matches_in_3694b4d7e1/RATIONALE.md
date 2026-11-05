# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3694b4d7e1aa02f917f9d18c550fbb49b96efa83 ("Fix incorrect search for "x?" style matches in creviterdissect()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/regex/regexec.c

Failing oracle cases:
- `src/test/regress||regex`
