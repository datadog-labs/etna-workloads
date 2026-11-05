cat > t.pgc <<'X'
EXEC SQL define A;
EXEC SQL define B;
EXEC SQL ifdef A;
int branch_a;
EXEC SQL elif B;
int branch_b;
EXEC SQL else;
int branch_else;
EXEC SQL endif;
X
ecpg -o - t.pgc 2>&1 | grep branch
rm -f t.pgc
