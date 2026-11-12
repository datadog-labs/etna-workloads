.mode list
.nullvalue NULL
set errors_as_json=true;
SELECT 1, 2 FROM json_execute_serialized_sql(json_serialize_sql('SELECT * FROM no_such_tbl'));
