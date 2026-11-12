CREATE VIEW m AS SELECT * FROM read_parquet('data/parquet-testing/bug3734.parquet', schema=map {
 'principals': {name: 'principals', type: 'STRUCT(category VARCHAR, characters VARCHAR[])', default_value: NULL,
  children: map {
   'category': {name: 'category', type: 'VARCHAR', default_value: NULL},
   'characters': {name: 'characters', type: 'VARCHAR[]', default_value: NULL,
     children: map {'list': {name: 'element', type: 'VARCHAR', default_value: NULL}}}}}});
SELECT UNNEST(principals) FROM m;
