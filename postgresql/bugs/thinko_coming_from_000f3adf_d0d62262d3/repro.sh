d=$(mktemp -d "$PWD/bbXXXX")
pg_basebackup -D "$d/b" --gzip --no-sync --format t -X stream 2>&1
ls "$d/b"
rm -rf "$d"
