.dbconfig defensive off
PRAGMA page_size=1024;
CREATE VIRTUAL TABLE f USING fts3(a, b);
INSERT INTO f_segdir VALUES(0,2,1111,0,0,X'00');
INSERT INTO f_segdir VALUES(0,3,0   ,0,0,X'00013003010200');
INSERT INTO f(f) VALUES ('merge=107,2');
SELECT 'done';
