# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 30dbdbe75384bcb034172c781b24bc982434a967 ("Fix failure to detect some cases of improperly-nested aggregates."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_agg.c

Failing oracle cases:
- `src/test/regress||aggregates`
