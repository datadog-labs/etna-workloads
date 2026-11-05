# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 18f0de6b885a017dfba620e0b9a5f42a1bc16d25 ("Prevent walsummarizer from getting stuck at a timeline switch."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/postmaster/walsummarizer.c

Failing oracle cases:
- `src/bin/pg_walsummary|t/003_tli_switch.pl|WAL summarization on node3 advanced past timeline switch`
- `src/bin/pg_walsummary|t/003_tli_switch.pl|at least one summary from LSN 0/<N> or later`
- `src/bin/pg_walsummary|t/003_tli_switch.pl|pg_walsummary TLI 2 0<P>/30205A0: no blocks`
- `src/bin/pg_walsummary|t/003_tli_switch.pl|pg_walsummary TLI 2 0<P>/30205A0: no error`
