# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8f0a97dfffc5b5f48f609fb894befcdf761dd576 ("Fix segmentation fault in MergeInheritedAttribute()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||compression`
