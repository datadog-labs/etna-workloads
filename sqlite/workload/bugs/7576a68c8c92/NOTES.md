repro.sql: builds an fts3 table, writes two corrupt f_segdir rows (defensive mode off), then does an INSERT (test fts3corrupt4-37).
Clean shell: "database disk image is malformed" (exit 1). Buggy shell: assertion `nDoclist>0' failed in fts3SegWriterAdd (abort, exit 134), because the nDoclist==0 corruption check was removed.
