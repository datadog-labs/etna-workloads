D=$PWD/rh_tmp; mkdir -p $D
cat > $D/rh.c <<'C'
#include "postgres.h"
#include "fmgr.h"
#include "catalog/pg_type.h"
#include "nodes/makefuncs.h"
#include "rewrite/rowsecurity.h"
#include "utils/acl.h"
#include "utils/array.h"
#include "utils/builtins.h"
#include "utils/rel.h"
PG_MODULE_MAGIC;
static List *rh(CmdType c, Relation r)
{
	RowSecurityPolicy *p;
	Datum role = ObjectIdGetDatum(ACL_ID_PUBLIC);
	if (strcmp(RelationGetRelationName(r), "rt") != 0) return NIL;
	p = palloc0(sizeof(RowSecurityPolicy));
	p->policy_name = pstrdup("ext");
	p->polcmd = '*';
	p->roles = construct_array_builtin(&role, 1, OIDOID);
	p->qual = (Expr *) makeConst(BOOLOID, -1, InvalidOid, sizeof(bool), BoolGetDatum(false), false, true);
	p->with_check_qual = copyObject(p->qual);
	p->hassublinks = false;
	return list_make1(p);
}
void _PG_init(void) { row_security_policy_hook_restrictive = rh; }
C
INC=$(dirname $(command -v psql))/../include/server
gcc -fPIC -shared -I$INC -o $D/rh.so $D/rh.c || exit 1
psql -X -a -q <<SQL
LOAD '$D/rh.so';
CREATE TABLE rt(a int);
INSERT INTO rt VALUES (1),(2);
CREATE POLICY p1 ON rt USING (true);
ALTER TABLE rt ENABLE ROW LEVEL SECURITY;
CREATE ROLE ru; GRANT SELECT ON rt TO ru;
SET ROLE ru;
SELECT * FROM rt;
SQL
