SELECT '[1,2]'::jsonb @> '[1,2,2]'::jsonb;
SELECT '[1,2,2]'::jsonb <@ '[1,2]'::jsonb;
