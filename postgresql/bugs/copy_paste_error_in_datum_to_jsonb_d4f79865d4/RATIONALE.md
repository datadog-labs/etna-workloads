# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d4f79865d4207bd93fa00f521638c289f036e276 ("Fix copy-paste error in datum_to_jsonb_internal()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonb.c

Failing oracle cases:
- `src/test/regress||sqljson`
