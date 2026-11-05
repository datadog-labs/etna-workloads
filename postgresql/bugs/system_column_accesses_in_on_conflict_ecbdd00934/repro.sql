CREATE TABLE u(a int primary key, b text);
INSERT INTO u VALUES (1,'x');
INSERT INTO u VALUES (1,'y') ON CONFLICT(a) DO UPDATE SET b='z' RETURNING tableoid::regclass, xmax::text::int > 0 AS xmax_set;
