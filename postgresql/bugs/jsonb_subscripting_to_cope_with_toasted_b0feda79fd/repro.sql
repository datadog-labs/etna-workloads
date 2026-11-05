create temp table t(k text, j jsonb);
insert into t select repeat('xyz',1000), jsonb_build_object(repeat('xyz',1000), 1);
select (j)[k] from t;
select j->k from t;
select (jsonb_set('{}'::jsonb, array[k], '2'))::text = '{"' || k || '": 2}' from t;
update t set j['abc'] = '1';
select (j)[k] from t;
