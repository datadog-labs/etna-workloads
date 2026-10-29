PRAGMA trusted_schema=OFF;
CREATE TEMP TABLE temp2(a, b, CHECK(base64(b)==base64(b)));
INSERT INTO temp2(a,b) VALUES(1,'x'),('x','y');
SELECT * FROM temp2;
