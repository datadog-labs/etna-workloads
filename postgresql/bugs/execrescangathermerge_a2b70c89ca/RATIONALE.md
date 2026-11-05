# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a2b70c89ca1a5fcf6181d3c777d82e7b83d2de1b ("Fix ExecReScanGatherMerge."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/nodeGatherMerge.c

Failing oracle cases:
- `src/test/regress||select_parallel`
