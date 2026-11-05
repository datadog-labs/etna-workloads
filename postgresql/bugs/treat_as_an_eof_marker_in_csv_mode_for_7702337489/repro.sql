CREATE TABLE t(a text);
COPY t FROM PROGRAM 'printf "a\n\\\\.\nb\n"' CSV;
SELECT * FROM t ORDER BY 1;
