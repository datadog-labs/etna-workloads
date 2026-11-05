CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE TABLE p (id int4range, valid_at daterange, PRIMARY KEY (id, valid_at WITHOUT OVERLAPS));
CREATE TABLE f (id int4range, valid_at daterange, parent_id int4range,
  FOREIGN KEY (parent_id, PERIOD valid_at) REFERENCES p (id, PERIOD valid_at));
INSERT INTO p VALUES ('[1,2)', daterange('2018-01-01','2018-03-01'));
INSERT INTO f VALUES ('[2,3)', daterange('2018-01-15','2018-02-01'), '[1,2)');
UPDATE p SET valid_at = daterange('2018-01-15','2018-03-01') WHERE id='[1,2)';
SELECT * FROM p;
