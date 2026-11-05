# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 56d0ed3b756b2e3799a7bbc0ac89bc7657ca2c33 ("Give better hints for ambiguous or unreferenceable columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_relation.c

Failing oracle cases:
- `src/test/regress||insert_conflict`
- `src/test/regress||join`
- `src/test/regress||merge`
- `src/test/regress||rules`
- `src/test/regress||union`
