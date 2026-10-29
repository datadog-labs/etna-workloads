SELECT json_remove('[0,1,2,3,4]','$[4294967296]');
SELECT json_remove('[0,1,2,3,4]','$[4294967297]');
SELECT json_remove('[0,1,2,3,4]','$[42949672960]');
