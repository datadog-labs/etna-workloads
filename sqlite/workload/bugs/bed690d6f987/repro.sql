CREATE TABLE obj(x);
INSERT INTO obj VALUES('{name:"value"}');
CREATE TABLE one(y);
INSERT INTO one VALUES(1);
SELECT key, value FROM json_tree(obj.x) LEFT JOIN obj;
SELECT key, value FROM json_tree(obj.x), one LEFT JOIN obj WHERE obj.x!='';
SELECT key, value FROM one LEFT JOIN json_tree(obj.x), obj;
