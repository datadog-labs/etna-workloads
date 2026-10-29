SELECT json_remove('[0,1,2,3,4]','$[2]');
SELECT json_array_length(json_remove('[1,2,3,4]','$[2]'));
