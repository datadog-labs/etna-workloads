# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c06e3550dc4163c3ff29a87283b605f0beb50bed ("Don't request pretty-printed output from xmlNodeDump()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/xml.c

Failing oracle cases:
- `src/test/regress||xml`
