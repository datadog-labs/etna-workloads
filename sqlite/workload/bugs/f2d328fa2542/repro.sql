CREATE VIRTUAL TABLE t USING fts5(x);
INSERT INTO t SELECT 'w'||value||' w'||value||'x w'||(value/2) FROM generate_series(1,3000);
CREATE VIRTUAL TABLE v USING fts5vocab(t,'row');
SELECT count(*), sum(doc), sum(cnt) FROM v;
