SELECT json_set('[0x1F]', '$[1]', 2), json_valid('[31,2]');
SELECT json_valid(json_set('{k:1}','$.v', printf('%.*c',120,'x')));
