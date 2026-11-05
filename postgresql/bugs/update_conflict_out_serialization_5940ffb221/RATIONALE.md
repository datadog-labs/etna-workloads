# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5940ffb221316ab73e6fdc780dfe9a07d4221ebb ("Avoid update conflict out serialization anomalies."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/heap/heapam.c

Failing oracle cases:
- `src/test/isolation||update-conflict-out`
