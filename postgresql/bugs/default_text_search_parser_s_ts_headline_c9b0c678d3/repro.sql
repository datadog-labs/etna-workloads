SELECT ts_headline('simple', '1 2 3 1 3'::text, '1 & 3', 'MaxWords=4, MinWords=1');
SELECT ts_headline('simple', '1 2 3 1 3'::text, '1 <-> 3', 'MaxWords=4, MinWords=1');
SELECT ts_headline('english','Lorem ipsum urna.  Nullam nullam ullamcorper urna.',
to_tsquery('english','Lorem') && phraseto_tsquery('english','ullamcorper urna'),
'MaxWords=100, MinWords=1');
