# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e568e1eee4650227170cf8c64eedb74bafd7d1f0 ("Again match pg_user_mappings to information_schema.user_mapping_options."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/system_views.sql

Failing oracle cases:
- `src/test/regress||foreign_data`
- `src/test/regress||rules`
