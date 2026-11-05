CREATE ROLE ru1;
CREATE ROLE ru2;
CREATE TYPE deptest_t AS (a int);
ALTER TYPE deptest_t OWNER TO ru1;
REASSIGN OWNED BY ru1 TO ru2;
SELECT typowner = relowner FROM pg_type JOIN pg_class c ON typrelid = c.oid WHERE typname = 'deptest_t';
