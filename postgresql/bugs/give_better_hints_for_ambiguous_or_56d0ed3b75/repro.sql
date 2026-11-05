create temp table j1(i int, t text);
create temp table j2(i int);
\set VERBOSITY default
SELECT * FROM (j1 JOIN j2 USING (i)) AS x WHERE j1.t = 'a';
