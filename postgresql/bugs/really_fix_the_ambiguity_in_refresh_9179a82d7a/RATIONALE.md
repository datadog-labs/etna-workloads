# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9179a82d7af38112cd0f6e84ab62d0b3592a6e0e ("Really fix the ambiguity in REFRESH MATERIALIZED VIEW CONCURRENTLY."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/matview.c

Failing oracle cases:
- `src/test/regress||matview`
