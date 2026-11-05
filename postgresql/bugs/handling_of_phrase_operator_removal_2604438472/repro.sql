SELECT to_tsquery('english', '1 <-> (a <-> 2)');
SELECT to_tsquery('english', '1 <3> (a <-> 2)');
SELECT to_tsquery('english', '(2 <-> (a <-> 1)) <-> s');
