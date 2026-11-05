SELECT jsonb_path_exists('[{"a": 1}]', '$undefined_var');
SELECT jsonb_path_exists('[{"a": 1}]', '$undefined_var', silent => true);
