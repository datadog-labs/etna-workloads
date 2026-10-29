repro.sql loads the corrupt FTS5 database from fts5corrupt3-14.0 via .open --hexdb, then runs INSERT INTO t1(t1) VALUES('optimize').
Clean shell: reports 'fts5: corruption found reading blob ...' (exit 1). Buggy shell: aborts on assertion fts5LeafFirstTermOff(pIter->pLeaf)==4 in fts5SegIterInit (assert instead of assert_nc).
