select '$ ? (@ like_regex "pattern" flag "xsms")'::jsonpath;
select jsonb_path_query('["abc", "ab\nadc"]', 'lax $[*] ? (@ like_regex "^ab.*c")');
select jsonb_path_query('["abc", "ab\nadc"]', 'lax $[*] ? (@ like_regex "^ab.*c" flag "s")');
