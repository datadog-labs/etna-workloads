# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1bf2518dd67be58b207979a66db7bb7c94b93a62 ("Fix EXIT out of outermost block in plpgsql."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpgsql/src/pl_comp.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_control`
