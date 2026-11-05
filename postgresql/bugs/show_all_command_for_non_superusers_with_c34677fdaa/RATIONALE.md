# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c34677fdaa73f089d557554a9cd479b9bd5b5143 ("Fix SHOW ALL command for non-superusers with replication connection"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/replication/walsender.c

Failing oracle cases:
- `src/test/recovery|t/001_stream_rep.pl|BASE_BACKUP cannot run in session already running backup: exit code not 0`
- `src/test/recovery|t/001_stream_rep.pl|BASE_BACKUP cannot run in session already running backup: matches`
- `src/test/recovery|t/001_stream_rep.pl|Name of login trigger`
- `src/test/recovery|t/001_stream_rep.pl|Name of login trigger#2`
- `src/test/recovery|t/001_stream_rep.pl|READ_REPLICATION_SLOT exit code 0 on success`
- `src/test/recovery|t/001_stream_rep.pl|READ_REPLICATION_SLOT returns NULL values if slot does not exist`
- `src/test/recovery|t/001_stream_rep.pl|READ_REPLICATION_SLOT returns tuple with slot information`
- `src/test/recovery|t/001_stream_rep.pl|READ_REPLICATION_SLOT success with existing slot`
- `src/test/recovery|t/001_stream_rep.pl|SHOW ALL with replication role and logical replication`
- `src/test/recovery|t/001_stream_rep.pl|SHOW ALL with replication role and physical replication`
- `src/test/recovery|t/001_stream_rep.pl|SHOW with superuser-settable parameter, replication role and logical replication`
- `src/test/recovery|t/001_stream_rep.pl|SHOW with superuser-settable parameter, replication role and physical replication`
- `src/test/recovery|t/001_stream_rep.pl|SHOW with user-settable parameter, replication role and logical replication`
- `src/test/recovery|t/001_stream_rep.pl|SHOW with user-settable parameter, replication role and physical replication`
- `src/test/recovery|t/001_stream_rep.pl|WAL receiver generates statistics for WAL writes`
- `src/test/recovery|t/001_stream_rep.pl|WAL segment <N> recycled after physical slot advancing`
- `src/test/recovery|t/001_stream_rep.pl|WAL sender sending base backup killed`
- `src/test/recovery|t/001_stream_rep.pl|base backup cleanly canceled`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of cascaded slot null with no hs_feedback`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of cascaded slot still null with hs_feedback`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of cascaded slot still null with hs_feedback reset`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of cascaded slot still null with hs_feedback unchanged`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of non-cascaded slot null with no hs_feedback`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of non-cascaded slot still null with hs_feedback`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of non-cascaded slot still null with hs_feedback reset`
- `src/test/recovery|t/001_stream_rep.pl|catalog xmin of non-cascaded slot still null with hs_feedback unchanged`
- `src/test/recovery|t/001_stream_rep.pl|physical slot advance persists across restarts`
- `src/test/recovery|t/001_stream_rep.pl|physical slot created on intermediate replica`
- `src/test/recovery|t/001_stream_rep.pl|physical slot created on primary`
- `src/test/recovery|t/001_stream_rep.pl|slot advancing with physical slot`
- `src/test/recovery|t/001_stream_rep.pl|standby_2 didn't replay primary value 4`
- `src/test/recovery|t/001_stream_rep.pl|xmin of cascaded slot non-null with hs feedback`
- `src/test/recovery|t/001_stream_rep.pl|xmin of cascaded slot null with hs feedback reset`
- `src/test/recovery|t/001_stream_rep.pl|xmin of cascaded slot null with no hs_feedback`
- `src/test/recovery|t/001_stream_rep.pl|xmin of cascaded slot with hs feedback has changed`
- `src/test/recovery|t/001_stream_rep.pl|xmin of non-cascaded slot non-null with hs feedback`
- `src/test/recovery|t/001_stream_rep.pl|xmin of non-cascaded slot null with hs feedback reset`
- `src/test/recovery|t/001_stream_rep.pl|xmin of non-cascaded slot null with no hs_feedback`
- `src/test/recovery|t/001_stream_rep.pl|xmin of non-cascaded slot with hs feedback has changed`
