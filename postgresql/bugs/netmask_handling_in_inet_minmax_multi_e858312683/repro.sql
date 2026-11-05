CREATE TABLE brin_test_inet (a inet);
CREATE INDEX ON brin_test_inet USING brin (a inet_minmax_multi_ops);
INSERT INTO brin_test_inet VALUES ('127.0.0.1/0');
INSERT INTO brin_test_inet VALUES ('0.0.0.0/12');
SELECT count(*) FROM brin_test_inet;
