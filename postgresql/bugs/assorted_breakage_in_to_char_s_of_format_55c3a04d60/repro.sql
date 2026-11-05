SET timezone = '+02:00';
SELECT to_char(timestamptz '2020-01-01 00:00:00+00', 'OF');
SET timezone = '00:30';
SELECT to_char(timestamptz '2020-01-01 00:00:00+00', 'OF');
SET timezone = '04:30';
SELECT to_char(timestamptz '2020-01-01 00:00:00+00', 'OF');
