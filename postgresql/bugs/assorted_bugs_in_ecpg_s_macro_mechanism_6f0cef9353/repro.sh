cat > $PWD/t_repro.pgc <<'X'
EXEC SQL DEFINE FOO 1;
EXEC SQL UNDEF FOO;
EXEC SQL ifdef FOO;
int defined_after_undef;
EXEC SQL else;
int not_defined_after_undef;
EXEC SQL endif;
X
ecpg -DFOO -o - t_repro.pgc
rm -f t_repro.pgc
