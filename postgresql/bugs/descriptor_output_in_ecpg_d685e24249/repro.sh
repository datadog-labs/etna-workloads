cat > t.pgc <<'X'
int main(void){
EXEC SQL BEGIN DECLARE SECTION;
int x;
EXEC SQL END DECLARE SECTION;
EXEC SQL ALLOCATE DESCRIPTOR indesc;
EXEC SQL EXECUTE foo1 USING SQL DESCRIPTOR indesc;
return 0;}
X
ecpg -o t.c t.pgc
grep ECPGt_descriptor t.c
