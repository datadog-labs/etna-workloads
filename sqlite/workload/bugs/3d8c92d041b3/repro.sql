ALTER TABLE generate_series RENAME TO flubber;
ALTER TABLE generate_series RENAME start TO flubber;
ALTER TABLE generate_series DROP COLUMN start;
ALTER TABLE pragma_compile_options RENAME TO flubber;
