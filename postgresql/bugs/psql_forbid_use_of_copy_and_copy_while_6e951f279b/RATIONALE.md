# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6e951f279beab566efa267151d028c3684f6095e ("psql: Forbid use of COPY and \copy while in a pipeline"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/common.c

Failing oracle cases:
- `src/bin/psql|t/001_basic.pl|COPY FROM in pipeline: fails: matches`
- `src/bin/psql|t/001_basic.pl|COPY TO in pipeline: fails: exit code not 0`
- `src/bin/psql|t/001_basic.pl|COPY TO in pipeline: fails: matches`
- `src/bin/psql|t/001_basic.pl|\copy from in pipeline: fails: matches`
- `src/bin/psql|t/001_basic.pl|\copy to in pipeline: fails: matches`
