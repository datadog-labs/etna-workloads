CREATE OPERATOR === (LEFTARG=bigint, RIGHTARG=bigint, PROCEDURE=int8eq);
CREATE OPERATOR !== (LEFTARG=bigint, RIGHTARG=bigint, PROCEDURE=int8ne, NEGATOR = ===);
DROP OPERATOR ===(bigint,bigint);
SELECT count(*) FROM pg_operator fk WHERE oprnegate<>0 AND NOT EXISTS(SELECT 1 FROM pg_operator pk WHERE pk.oid=fk.oprnegate);
