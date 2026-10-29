SELECT ifnull(substr('abcdefg',NULL,1),'nil');
SELECT ifnull(substring('abcdefg',NULL),'nil');
SELECT ifnull(substr('abcdefg',1,NULL),'nil');
