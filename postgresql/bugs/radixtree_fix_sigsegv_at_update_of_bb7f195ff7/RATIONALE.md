# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bb7f195ff78851e5fcee7230108a16d70be13579 ("radixtree: Fix SIGSEGV at update of embeddable value to non-embeddable."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/include/lib/radixtree.h

Failing oracle cases:
- `src/test/modules/test_tidstore||test_tidstore`
