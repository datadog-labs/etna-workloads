\set VERBOSITY default
select '{ "a":  "\ud83d\ud83d" }'::json -> 'a';
select '{ "a":  "\ude04X" }'::jsonb;
select '{ "a":  "null \u0000 escape" }'::json ->> 'a';
