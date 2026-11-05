# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6cf1647d87e7cd423d71525a8759b75c4e4a47ec ("Fix header check for continuation records where standbys could be stuck"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlogrecovery.c

Failing oracle cases:
- `src/test/recovery|t/043_no_contrecord_switch.pl|check streamed content on standby2`
