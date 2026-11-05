cat > t.pgc <<'X'
EXEC SQL BEGIN DECLARE SECTION;
bytea gb[16];
EXEC SQL END DECLARE SECTION;
void f(void)
{
	EXEC SQL BEGIN DECLARE SECTION;
	bytea lb[16];
	EXEC SQL END DECLARE SECTION;
	EXEC SQL DECLARE c CURSOR FOR SELECT d FROM t WHERE d = :lb;
}
void g(void)
{
	EXEC SQL OPEN c;
	EXEC SQL FETCH c INTO :gb;
}
X
ecpg -o - t.pgc 2>&1 | grep -v '^#line'
rm -f t.pgc
