Reproducer (repro.sql) is the fts4merge 6.1 test: four 900-char rows inserted in two
transactions, then 'merge=1,2' run twice on an FTS4 table. The second merge has a single
input segment.
Clean shell: no output, exit 0. Buggy shell: assertion `nSeg>=2' fails in
fts3IncrmergeCsr and the shell aborts (exit -6).
