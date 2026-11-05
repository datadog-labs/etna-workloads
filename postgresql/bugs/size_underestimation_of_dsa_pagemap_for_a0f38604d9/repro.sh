# Helper C function (same as test_dsa_allocate in src/test/modules/test_dsa).
W=$(mktemp -d "$PWD/dsaXXXXXX")
cat > "$W/t.c" <<'CSRC'
#include "postgres.h"
#include "fmgr.h"
#include "storage/lwlock.h"
#include "utils/dsa.h"
#include "utils/freepage.h"
PG_MODULE_MAGIC;
PG_FUNCTION_INFO_V1(test_dsa_allocate);
Datum
test_dsa_allocate(PG_FUNCTION_ARGS)
{
	int s = PG_GETARG_INT32(0), e = PG_GETARG_INT32(1), step = PG_GETARG_INT32(2);
	size_t n;
	int tr = LWLockNewTrancheId();
	LWLockRegisterTranche(tr, "test_dsa");
	for (n = s; n < e; n += step)
	{
		dsa_area *a = dsa_create(tr);
		dsa_pointer dp = dsa_allocate(a, n * FPM_PAGE_SIZE);
		dsa_free(a, dp);
		dsa_detach(a);
	}
	PG_RETURN_VOID();
}
CSRC
gcc -shared -fPIC -I"$(dirname "$(command -v psql)")/../include/server" -o "$W/t.so" "$W/t.c" || exit 1
psql -X -q -c "CREATE FUNCTION test_dsa_allocate(int, int, int) RETURNS void AS '$W/t.so', 'test_dsa_allocate' LANGUAGE C STRICT"
echo "SELECT test_dsa_allocate(1001, 2000, 100);" | psql -X -q
echo "SELECT test_dsa_allocate(6501, 6600, 100);" | psql -X -q
rm -rf "$W"
