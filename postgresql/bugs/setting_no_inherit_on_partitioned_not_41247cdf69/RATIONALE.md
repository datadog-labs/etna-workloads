# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 41247cdf695b99eb4b6359ef3d6bdcfbad321847 ("Prevent setting NO INHERIT on partitioned NOT NULL constraints"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||constraints`
