# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b69bdcee9c9cfd8550c4e847d035f441fcee7d01 ("Avoid assertion due to disconnected NFA sub-graphs in regex parsing."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/regex/regc_color.c, src/backend/regex/regc_nfa.c, src/backend/regex/regcomp.c, src/include/regex/regguts.h

Failing oracle cases:
- `src/test/modules/test_regex||test_regex`
