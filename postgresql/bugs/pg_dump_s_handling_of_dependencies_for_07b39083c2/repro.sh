psql -X -q -c "CREATE SCHEMA s;
CREATE OPERATOR s.~~ (PROCEDURE = int4eq, LEFTARG = int, RIGHTARG = int);
CREATE OPERATOR CLASS s.oc FOR TYPE int USING btree AS OPERATOR 3 s.~~;
CREATE TYPE s.rt AS RANGE (subtype = int, subtype_opclass = s.oc);"
pg_dump -s -n s | grep -E '^CREATE (OPERATOR|TYPE)' | sed 's/ (.*//'
