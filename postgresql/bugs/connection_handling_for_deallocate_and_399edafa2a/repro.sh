cat > r.pgc <<'X'
int main(void)
{
	EXEC SQL CONNECT TO postgres AS con1;
	EXEC SQL AT con1 DECLARE stmt_2 STATEMENT;
	EXEC SQL PREPARE stmt_2 FROM "SELECT 1";
	EXEC SQL DEALLOCATE PREPARE stmt_2;
	return 0;
}
X
ecpg -o - r.pgc 2>&1 | grep -i -E 'deallocate|prepare'
rm -f r.pgc
