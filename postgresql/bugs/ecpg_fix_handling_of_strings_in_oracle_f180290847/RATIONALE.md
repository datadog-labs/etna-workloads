# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f18029084784ec71a2e825cfcfd81b06d597ab93 ("ecpg: Fix handling of strings in ORACLE compat code with SQLDA"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/interfaces/ecpg/ecpglib/data.c

Failing oracle cases:
- `src/interfaces/ecpg||compat_oracle/char_array`
