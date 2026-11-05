SELECT ts_headline('english',
'Lorem ipsum urna.  Nullam nullam ullamcorper urna.',
phraseto_tsquery('english','ullamcorper urna'),
'MaxWords=100, MinWords=5');
SELECT ts_headline('english', 'a b c d a x x x x x b', to_tsquery('a & b'), 'MaxWords=5, MinWords=2');
