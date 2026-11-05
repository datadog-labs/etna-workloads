touch "$PGDATA/.DS_Store"
D=$PWD/bk_tmp
rm -rf "$D"
pg_basebackup -D "$D" -Ft -Xnone --no-sync 2>&1
if tar tf "$D/base.tar" | grep -q '^\.DS_Store$'; then echo copied; else echo skipped; fi
rm -rf "$D"
