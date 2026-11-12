SET storage_compatibility_version='v1.4.0';
SELECT json_serialize_sql('SELECT q.id FROM u q INNER JOIN p t NEAREST 2 BY DISTANCE array_distance(q.e, t.e)') LIKE '%error":true%';
