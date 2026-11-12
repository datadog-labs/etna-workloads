CREATE SEQUENCE s;
SELECT count(*) FROM (SELECT row_number() OVER (ORDER BY nextval('s')) FROM range(3)) t;
