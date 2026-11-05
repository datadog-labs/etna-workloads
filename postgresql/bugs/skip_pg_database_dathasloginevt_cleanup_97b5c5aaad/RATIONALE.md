# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 97b5c5aaad5dba2144215293d4b8438df693c13b ("Skip pg_database.dathasloginevt cleanup on standby"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/event_trigger.c

Failing oracle cases:
- `src/test/recovery|t/053_standby_login_event_trigger.pl|no AccessExclusiveLock FATAL on standby login`
- `src/test/recovery|t/053_standby_login_event_trigger.pl|standby accepts connection to database with dangling dathasloginevt`
