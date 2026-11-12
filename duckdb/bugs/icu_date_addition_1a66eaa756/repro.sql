SET TimeZone = 'America/Los_Angeles';
SELECT '290309-12-22 (BC) 00:00:00Z'::TIMESTAMPTZ + INTERVAL (-1) microsecond;
