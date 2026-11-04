select unnest(struct(1,2,3)) as ignored_alias;
describe select unnest(struct(1,2,3)) as ignored_alias;
CREATE TABLE t AS VALUES (struct('a','b',struct('c'))), (struct('d','e',struct('f')));
select unnest(column1) c1 from t;
