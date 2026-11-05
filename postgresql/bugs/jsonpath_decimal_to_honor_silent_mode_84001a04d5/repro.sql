select jsonb_path_query('12345.678', '$.decimal(0, 6)', silent => true);
select jsonb_path_query('1234.5678', '$.decimal(6, 1001)', silent => true);
select '1234.5678'::jsonb @? '$.decimal(0)';
