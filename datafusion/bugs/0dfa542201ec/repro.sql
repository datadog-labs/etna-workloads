CREATE TABLE issue_20437_small AS
SELECT id, arrow_cast(region, 'Dictionary(Int32, Utf8)') AS region
FROM (VALUES (1, 'west'), (2, 'west')) AS t(id, region);

CREATE TABLE issue_20437_large AS
SELECT id, region, value
FROM (VALUES (1, 'west', 100), (2, 'west', 200), (3, 'east', 300)) AS t(id, region, value);

SELECT s.id, s.region, l.value
FROM issue_20437_small s
JOIN issue_20437_large l ON s.id = l.id AND s.region = l.region
ORDER BY s.id;
