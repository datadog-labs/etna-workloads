CREATE VIRTUAL TABLE t3 USING fts4;
REPLACE INTO t3(docid, content) VALUES (1, 'one two');
REPLACE INTO t3(docid, content) VALUES (2, 'one two three four');
REPLACE INTO t3(docid, content) VALUES (1, 'one two three four five six');
UPDATE OR REPLACE t3 SET docid = 2 WHERE docid=1;
SELECT quote(matchinfo(t3, 'na')) FROM t3 WHERE t3 MATCH 'six';
