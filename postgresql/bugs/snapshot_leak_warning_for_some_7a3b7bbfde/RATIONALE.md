# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7a3b7bbfded3142aaa8edae2dbc88999568cc1cd ("Fix snapshot leak warning for some procedures"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/mmgr/portalmem.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_transaction`
