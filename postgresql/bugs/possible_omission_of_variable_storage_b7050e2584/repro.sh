cat > v.pgc <<'X'
int main(void)
{
	exec sql begin declare section;
	static varchar vc1[50], vc2[50], vc3[255];
	exec sql end declare section;
	return 0;
}
X
ecpg -o - v.pgc | grep varchar_
rm -f v.pgc
