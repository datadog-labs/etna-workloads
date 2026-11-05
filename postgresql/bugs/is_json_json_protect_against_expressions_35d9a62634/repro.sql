CREATE FUNCTION s_in(cstring) RETURNS s_t AS 'textin' LANGUAGE internal IMMUTABLE STRICT;
CREATE FUNCTION s_out(s_t) RETURNS cstring AS 'textout' LANGUAGE internal IMMUTABLE STRICT;
CREATE TYPE s_t (INPUT = s_in, OUTPUT = s_out, LIKE = text, CATEGORY = 'S');
SELECT '{"a":1}'::s_t IS JSON;
SELECT JSON('{"a":1}'::s_t WITH UNIQUE KEYS);
