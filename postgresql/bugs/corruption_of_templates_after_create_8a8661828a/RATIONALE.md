# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8a8661828ae14e4d3b6beac5e8d8b37bd4e79004 ("Fix corruption of templates after CREATE DATABASE .. STRATEGY WAL_LOG"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/dbcommands.c

Failing oracle cases:
- `src/test/recovery|t/034_create_database.pl|check that table exists on template after crash, with checkpoint`
