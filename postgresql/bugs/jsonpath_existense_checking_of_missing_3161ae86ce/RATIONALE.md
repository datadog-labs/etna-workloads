# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3161ae86ce3ced0a91c2d3cdbbdc602d6e19892d ("Fix jsonpath existense checking of missing variables"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonpath_exec.c

Failing oracle cases:
- `src/test/regress||jsonb_jsonpath`
