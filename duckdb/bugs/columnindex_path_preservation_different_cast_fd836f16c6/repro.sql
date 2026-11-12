.mode list
.nullvalue NULL
CREATE TABLE cast_parent(n STRUCT(x STRUCT(a INTEGER, b INTEGER)));
INSERT INTO cast_parent VALUES
	({'x': {'a': 1, 'b': 11}}),
	({'x': {'a': 2, 'b': 22}}),
	({'x': NULL}),
	(NULL);
CREATE VIEW cast_parent_view AS SELECT * FROM cast_parent;
SELECT n.x::STRUCT(b INTEGER, a BIGINT), n.x.a FROM cast_parent;
SELECT n.x.a, n.x::STRUCT(b INTEGER, a BIGINT) FROM cast_parent;
SELECT n.x.a, n.x::STRUCT(b INTEGER, a BIGINT), n.x FROM cast_parent;
SELECT n.x::STRUCT(b INTEGER, a BIGINT), n.x.a FROM cast_parent_view;
SELECT n.x.a, n.x::STRUCT(b INTEGER, a BIGINT) FROM cast_parent_view;
