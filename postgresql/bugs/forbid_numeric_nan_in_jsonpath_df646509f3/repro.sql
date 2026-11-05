select jsonb_path_query('"nan"', '$.double()');
select jsonb_path_query('"NaN"', '$.double()');
