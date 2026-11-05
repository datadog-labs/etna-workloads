# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c96de42c4b5f5d7bf785265cf26836326e28c6b6 ("Further refine _SPI_execute_plan's rule for atomic execution."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/spi.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_call`
