# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4f1124548f6f3c7dea639ccd3d3f234cf70faf0a ("Check the validity of commutators for merge/hash clauses"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinpath.c

Failing oracle cases:
- `src/test/regress||equivclass`
