SELECT count(*) > 0 AS found FROM pg_conversion;
SELECT conname, (pg_identify_object('pg_conversion'::regclass, oid, 0)).identity,
       (pg_identify_object_as_address('pg_conversion'::regclass, oid, 0)).object_names
FROM pg_conversion WHERE conname = 'utf8_to_big5';
