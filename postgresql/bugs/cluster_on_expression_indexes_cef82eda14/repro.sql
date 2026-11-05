CREATE TABLE ce(id serial primary key, a int, b text COLLATE "C");
INSERT INTO ce(a, b) SELECT g.i % 42, 'prefix'||g.i FROM generate_series(1, 133) g(i);
CREATE INDEX ce_minus_a ON ce ((-a), b);
CLUSTER ce USING ce_minus_a;
SELECT count(*) FROM ce;
