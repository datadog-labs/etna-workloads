# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 97ddda8a82ac470ae581d0eb485b6577707678bc ("Fix data loss in wal_level=minimal crash recovery of CREATE TABLESPACE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablespace.c

Failing oracle cases:
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, COPY with INSERT triggers`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, CREATE TABLESPACE, CREATE INDEX`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, CREATE+SET TABLESPACE`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, INSERT COPY`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, SET TABLESPACE abort subtransaction`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, SET TABLESPACE commit subtransaction`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, SET TABLESPACE nested subtransaction`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, SET TABLESPACE, hint bit`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, TRUNCATE COPY`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, TRUNCATE COPY INSERT`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, TRUNCATE COPY with TRUNCATE triggers`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, TRUNCATE INSERT`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, TRUNCATE INSERT PREPARE`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, TRUNCATE with empty table`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, UPDATE touches two buffers for one row`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, end-of-xact WAL`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, no orphan relfilenode remains`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, unique index LP_DEAD`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = minimal, unique index LP_DEAD message`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, COPY with INSERT triggers`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, CREATE TABLESPACE, CREATE INDEX`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, CREATE+SET TABLESPACE`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, INSERT COPY`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, SET TABLESPACE abort subtransaction`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, SET TABLESPACE commit subtransaction`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, SET TABLESPACE nested subtransaction`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, SET TABLESPACE, hint bit`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, TRUNCATE COPY`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, TRUNCATE COPY INSERT`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, TRUNCATE COPY with TRUNCATE triggers`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, TRUNCATE INSERT`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, TRUNCATE INSERT PREPARE`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, TRUNCATE with empty table`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, UPDATE touches two buffers for one row`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, end-of-xact WAL`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, no orphan relfilenode remains`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, unique index LP_DEAD`
- `src/test/recovery|t/018_wal_optimize.pl|wal_level = replica, unique index LP_DEAD message`
