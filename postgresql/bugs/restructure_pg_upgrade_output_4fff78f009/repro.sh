D=$PWD/tmp_up; rm -rf $D; mkdir $D; cd $D
initdb -D old >/dev/null 2>&1
initdb -D new >/dev/null 2>&1
pg_upgrade -b "$(dirname $(which initdb))" -B "$(dirname $(which initdb))" -d old -D new -s $D -c >/dev/null 2>&1
echo "check rc=$?"
if [ -e new/pg_upgrade_output.d ]; then echo "output dir remains"; else echo "output dir removed"; fi
pg_upgrade -b "$(dirname $(which initdb))" -B "$(dirname $(which initdb))" -d old -D new -s $D -c >/dev/null 2>&1
echo "second check rc=$?"
cd ..; rm -rf $D
