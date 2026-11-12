.mode list
.nullvalue NULL
SET Calendar='gregorian';
SET TimeZone='Asia/Singapore';
CREATE OR REPLACE TABLE single(c0 TIME WITH TIME ZONE);
INSERT INTO single(c0) VALUES ('12:34:56');
SELECT 
	c0, 
	c0::TIME AS t,
	c0::TIME::TIMETZ AS tz,
FROM single;
SELECT 
	(c0::TIME = '12:34:56') AS e,
	(c0::TIME <> '12:34:56') AS u,
	(c0::TIME IN ('12:34:56')) AS i,
	(c0::TIME NOT IN ('12:34:56')) AS n,
FROM single;
