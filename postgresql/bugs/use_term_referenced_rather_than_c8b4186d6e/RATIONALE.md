# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c8b4186d6eef1bb310708e02aa872947fba87e9f ("Use term "referenced" rather than "dependent" in dependency locking"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/pg_depend.c

Failing oracle cases:
- `src/test/isolation||ddl-dependency-locking`
