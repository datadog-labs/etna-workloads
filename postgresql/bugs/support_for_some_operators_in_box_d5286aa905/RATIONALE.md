# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d5286aa905c9173b3fc4f911682089149bd3caef ("Fix support for some operators (&<, &>, $<|, |&>) in box operator class of SP-GiST."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/geo_spgist.c

Failing oracle cases:
- `src/test/regress||box`
