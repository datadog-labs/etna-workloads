set datafusion.execution.target_partitions = 8;
set datafusion.optimizer.repartition_file_scans = false;

create table src (id int, ts int) as values (1, 10), (2, 20), (3, 30);

copy (select * from src) to 'data/0.parquet' stored as parquet;
copy (select * from src) to 'data/1.parquet' stored as parquet;
copy (select * from src) to 'data/2.parquet' stored as parquet;
copy (select * from src) to 'data/3.parquet' stored as parquet;

create external table t stored as parquet location 'data/';

select a.id
from t a
left join (select distinct on (id) id, ts from t order by id, ts) f on a.id = f.id
order by a.id;
