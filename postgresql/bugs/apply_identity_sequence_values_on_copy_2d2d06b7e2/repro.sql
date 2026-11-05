CREATE TABLE itest9 (a int GENERATED ALWAYS AS IDENTITY, b text, c bigint);
COPY itest9 (b, c) FROM stdin;
foo2	202
bar2	203
\.
SELECT * FROM itest9 ORDER BY c;
