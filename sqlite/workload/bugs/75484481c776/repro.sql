SELECT value FROM generate_series(1,10) WHERE value<5.5;
SELECT value FROM generate_series(1,10) WHERE value>=5.5;
SELECT value FROM generate_series(10,1,-1) WHERE value>=5.5;
SELECT value FROM generate_series(1,10) WHERE value==5.5;
