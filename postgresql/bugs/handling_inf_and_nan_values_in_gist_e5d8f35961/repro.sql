CREATE TABLE pt(f1 point);
INSERT INTO pt VALUES ('0,0'),('1e-300,-1e-300'),('-3,4'),('10,10'),('NaN,NaN'),('1e300,Infinity'),('Infinity,1e300'),('5.1,34.5');
CREATE INDEX pti ON pt USING gist(f1);
SET enable_seqscan=off; SET enable_bitmapscan=off;
SELECT * FROM pt ORDER BY f1 <-> '0,1';
