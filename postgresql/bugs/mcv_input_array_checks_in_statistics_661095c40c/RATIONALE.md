# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 661095c40c0bcbb9c49743f518417a2977b63aef ("Fix MCV input array checks in statistics restore functions"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/statistics/attribute_stats.c

Failing oracle cases:
- `src/test/regress||stats_import`
