# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e576f71fbe713d9357d1b480b4993043f7fcc73a ("Fix ecpg crash with bytea and cursor variables."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/interfaces/ecpg/preproc/ecpg.header

Failing oracle cases:
- `src/interfaces/ecpg||sql/bytea`
