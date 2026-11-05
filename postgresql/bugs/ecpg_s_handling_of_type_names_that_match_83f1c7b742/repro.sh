for kw in start name string text year data type comment; do
cat > t.pgc <<X
exec sql begin declare section;
typedef int $kw;
$kw x;
exec sql end declare section;
exec sql type ${kw}2 is char[11];
int main(void) { exec sql select 1 into :x; return 0; }
X
echo "== $kw"
ecpg -o - t.pgc 2>&1 | grep -v '^#\|^$' | head -20
done
rm -f t.pgc
