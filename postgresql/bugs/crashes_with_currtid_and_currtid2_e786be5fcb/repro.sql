CREATE TABLE tid_part (a int) PARTITION BY RANGE (a);
SELECT currtid('tid_part'::regclass::oid, '(0,1)'::tid);
SELECT currtid2('tid_part'::text, '(0,1)'::tid);
\echo done
