create table floats as values (1.0), (2.0), (3.0), (NULL), ('Nan');
create table float16s as select arrow_cast(column1, 'Float16') as column1 from floats;
SELECT
  column1 + 1::tinyint   as column1_plus_int8,
  column1 + 1::smallint  as column1_plus_int16,
  column1 + 1::int       as column1_plus_int32,
  column1 + 1::bigint    as column1_plus_int64,
  column1 + 1.0::float   as column1_plus_float32,
  column1 + 1.0          as column1_plus_float64
FROM float16s ORDER BY 1;
SELECT
  column1 = 1::tinyint   as e8,
  column1 = 1::smallint  as e16,
  column1 = 1::int       as e32,
  column1 = 1::bigint    as e64,
  column1 = 1.0::float   as ef32,
  column1 = 1.0          as ef64
FROM float16s ORDER BY 1;
select column1 + NULL from float16s;
select column1 = NULL from float16s;
