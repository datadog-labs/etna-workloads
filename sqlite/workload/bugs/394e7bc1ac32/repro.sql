SELECT subtype((SELECT json(0)));
SELECT subtype((SELECT json_group_array(1)));
SELECT json_array((SELECT json_group_array(1)));
