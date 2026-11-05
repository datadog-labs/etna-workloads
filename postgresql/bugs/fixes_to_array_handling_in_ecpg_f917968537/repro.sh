cat > t.pgc <<'XX'
int main(void)
{
	EXEC SQL BEGIN DECLARE SECTION;
	typedef struct { int id; int phone; } cust;
	cust *c;
	EXEC SQL END DECLARE SECTION;
	EXEC SQL SELECT 1, 2 INTO :c;
	return 0;
}
XX
ecpg -o - t.pgc | grep ECPGt_int
rm -f t.pgc
