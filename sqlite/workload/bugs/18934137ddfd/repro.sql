SELECT 'fooX' REGEXP '^[a-z][a-z0-9]{0,30}$';
SELECT 'fooX' REGEXP '^[a-z][a-z0-9]{0,2}X$';
SELECT 'foooX' REGEXP '^[a-z][a-z0-9]{0,3}X$';
