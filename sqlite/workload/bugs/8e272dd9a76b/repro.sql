SELECT quote(jsonb_group_array(1) FILTER (WHERE 0));
SELECT quote(jsonb_group_object('a',1) FILTER (WHERE 0));
