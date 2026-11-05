\set QUIET off
DO $$ BEGIN RAISE NOTICE 'first'; END $$\; SELECT 1 AS a\; DO $$ BEGIN RAISE NOTICE 'second'; END $$\; SELECT 2 AS b;
