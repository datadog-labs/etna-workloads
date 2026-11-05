# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4ba84de459532a7a79616e756f8bfd45ba4b8048 ("Avoid "you don't own a lock of type ExclusiveLock" in GRANT TABLESPACE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/cache/syscache.c

Failing oracle cases:
- `src/test/regress||tablespace`
