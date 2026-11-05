# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c3c35a733c77b298d3cf7e7de2eeb4aea540a631 ("Prevent infinite insertion loops in spgdoinsert()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/spgist/spgdoinsert.c

Failing oracle cases:
- `src/test/modules/spgist_name_ops||spgist_name_ops`
