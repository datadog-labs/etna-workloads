# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 984e5beb38a7c79a5a9243865d9598c405df17f6 ("Sort out paired double quotes in \connect, \password and \crosstabview."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/psqlscanslash.l

Failing oracle cases:
- `src/test/regress||psql_crosstab`
