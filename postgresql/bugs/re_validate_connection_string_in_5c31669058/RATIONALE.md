# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5c31669058b5550b4b3d623c07bc4203c11b8316 ("Re-validate connection string in libpqrcv_connect()."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/replication/libpqwalreceiver/libpqwalreceiver.c

Failing oracle cases:
- `src/test/subscription|t/027_nosuperuser.pl|subscription whose owner is a non-superuser must specify password parameter of the connection string`
