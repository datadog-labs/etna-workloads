# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f99870dd867331f576a84e37438da86a866559c4 ("Fix corruption of toast indexes with REINDEX CONCURRENTLY"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/common/toast_internals.c

Failing oracle cases:
- `src/test/isolation||reindex-concurrently-toast`
