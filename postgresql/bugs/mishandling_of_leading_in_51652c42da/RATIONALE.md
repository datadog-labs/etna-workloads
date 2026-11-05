# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 51652c42da2e982fb7028970eea5eed4c670a555 ("Fix mishandling of leading '\' in nondeterministic LIKE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/like_match.c

Failing oracle cases:
- `src/test/regress||collate.icu.utf8`
