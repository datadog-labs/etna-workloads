CREATE TYPE bogus AS ENUM ('good');
BEGIN;
ALTER TYPE bogus ADD VALUE 'new';
SELECT 'new'::bogus;
COMMIT;
SELECT enum_range(null::bogus);
