initdb --no-sync -D "$PWD/rtmp_y" -cwork_mem=128 -cWork_Mem=256 -cWORK_MEM=512 >/dev/null 2>&1
grep -i '^work_mem' "$PWD/rtmp_y/postgresql.conf"
rm -rf "$PWD/rtmp_y"
