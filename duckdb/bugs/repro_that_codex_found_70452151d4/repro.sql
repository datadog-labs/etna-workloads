CREATE TABLE e(dt DATE);
INSERT INTO e VALUES ('infinity'),('-infinity'),('2020-05-05'),(NULL);
SELECT year(dt) = 2020 FROM e ORDER BY dt NULLS LAST;
