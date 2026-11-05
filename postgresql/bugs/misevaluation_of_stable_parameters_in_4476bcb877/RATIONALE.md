# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4476bcb8773b306b9ca84bf2fadcf30acfa2c687 ("Fix misevaluation of STABLE parameters in CALL within plpgsql."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/functioncmds.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_transaction`
