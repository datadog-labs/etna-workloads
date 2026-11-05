select '[]'::jsonb || '"a"'::jsonb;
select '[]'::jsonb || '{"a":"b"}'::jsonb;
select '{"a":"b"}'::jsonb || '[]'::jsonb;
select '{}'::jsonb || '"a"'::jsonb;
