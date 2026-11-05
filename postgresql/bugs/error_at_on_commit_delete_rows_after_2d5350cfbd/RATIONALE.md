# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2d5350cfbdc6e61124214d68713295bb060bc541 ("Avoid ERROR at ON COMMIT DELETE ROWS after relhassubclass=f."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/vacuum.c

Failing oracle cases:
- `src/test/regress||maintain_every`
