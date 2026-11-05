cat > t.pgc <<'X'
int main(void)
{
  exec sql select 'abc''def', "foo""bar";
  return 0;
}
X
ecpg -o - t.pgc | grep ECPGdo
rm -f t.pgc
