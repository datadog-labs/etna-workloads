d=$(mktemp -d)
cat > $d/t.pgc <<'X'
int main(void)
{
	EXEC SQL CONNECT TO unix:postgresql://localhost/db?connect_timeout=180&client_encoding=sql_ascii AS main USER u;
	return 0;
}
X
ecpg -o - $d/t.pgc | grep ECPGconnect
rm -rf $d
