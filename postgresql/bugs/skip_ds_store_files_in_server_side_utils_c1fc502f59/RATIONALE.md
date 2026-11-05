# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c1fc502f595bc843a603bddd267b249272de485f ("Skip .DS_Store files in server side utils"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/backup/basebackup.c, src/bin/pg_checksums/pg_checksums.c, src/bin/pg_rewind/filemap.c

Failing oracle cases:
- `src/bin/pg_basebackup|t/010_pg_basebackup.pl|.DS_Store not copied`
- `src/bin/pg_checksums|t/002_actions.pl|checksums enabled in control file: matches`
- `src/bin/pg_checksums|t/002_actions.pl|checksums enabled in control file: matches#2`
- `src/bin/pg_checksums|t/002_actions.pl|checksums successfully disabled in cluster`
- `src/bin/pg_checksums|t/002_actions.pl|checksums successfully enabled in cluster`
- `src/bin/pg_checksums|t/002_actions.pl|checksums successfully enabled in cluster#2`
- `src/bin/pg_checksums|t/002_actions.pl|data_checksums=on is reported on an offline cluster stdout /(?^:^on$)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in 99990_fsm stderr /(?^:could not read block 0 in file.*99990_fsm\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in 99990_fsm.123 stderr /(?^:could not read block 0 in file.*99990_fsm.123\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in 99990_init stderr /(?^:could not read block 0 in file.*99990_init\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in 99990_init.123 stderr /(?^:could not read block 0 in file.*99990_init.123\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in 99990_vm stderr /(?^:could not read block 0 in file.*99990_vm\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in 99990_vm.123 stderr /(?^:could not read block 0 in file.*99990_vm.123\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in <N> stderr /(?^:could not read block 0 in file.*<N>\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails for corrupted data in <N>.123 stderr /(?^:could not read block 0 in file.*<N>.123\":)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data for single relfilenode on tablespace pg_default stderr /(?^:checksum verification failed)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data for single relfilenode on tablespace pg_default stdout /(?^:Bad checksums:.*1)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data for single relfilenode on tablespace ts_corrupt stderr /(?^:checksum verification failed)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data for single relfilenode on tablespace ts_corrupt stdout /(?^:Bad checksums:.*1)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data on tablespace pg_default stderr /(?^:checksum verification failed)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data on tablespace pg_default stdout /(?^:Bad checksums:.*1)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data on tablespace ts_corrupt stderr /(?^:checksum verification failed)/`
- `src/bin/pg_checksums|t/002_actions.pl|fails with corrupted data on tablespace ts_corrupt stdout /(?^:Bad checksums:.*1)/`
- `src/bin/pg_checksums|t/002_actions.pl|succeeds again after table drop on tablespace pg_default`
- `src/bin/pg_checksums|t/002_actions.pl|succeeds again after table drop on tablespace ts_corrupt`
- `src/bin/pg_checksums|t/002_actions.pl|succeeds for single relfilenode on tablespace pg_default with offline cluster`
- `src/bin/pg_checksums|t/002_actions.pl|succeeds for single relfilenode on tablespace ts_corrupt with offline cluster`
- `src/bin/pg_checksums|t/002_actions.pl|succeeds with foreign tablespace`
- `src/bin/pg_checksums|t/002_actions.pl|succeeds with offline cluster`
- `src/bin/pg_checksums|t/002_actions.pl|verifies checksums as default action`
- `src/bin/pg_rewind|t/003_extrafiles.pl|file lists match`
- `src/bin/pg_rewind|t/003_extrafiles.pl|file lists match#2`
