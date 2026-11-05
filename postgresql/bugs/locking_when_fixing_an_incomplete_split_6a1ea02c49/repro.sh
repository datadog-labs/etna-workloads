# Build a relocated mirror of the server install so that the injection_points
# test module (not installed in the build) can be found in its libdir/sharedir.
D=$(cd "$(dirname "$0")" && pwd)/ext
B=$(dirname "$(command -v postgres)")
R=$(dirname "$B")
M=$PWD/mirror
rm -rf $M $PWD/rc
mkdir -p $M/bin
cp -rs $R/lib $M/lib
cp -rs $R/share $M/share
for f in $B/*; do ln -s $f $M/bin/$(basename $f); done
for p in postgres pg_ctl initdb; do rm $M/bin/$p; cp $B/$p $M/bin/$p; done
cp $D/injection_points.so $M/lib/
cp $D/extension/* $M/share/extension/
PATH=$M/bin:$PATH
initdb -D $PWD/rc -A trust >/dev/null 2>&1
cat >> $PWD/rc/postgresql.conf <<EOC
listen_addresses = ''
unix_socket_directories = '$PWD/rc'
EOC
pg_ctl -D $PWD/rc -w -l $PWD/rc/log start >/dev/null 2>&1
psql -X -a -q -h $PWD/rc -d postgres < $D/body.sql 2>&1 | grep -v 'server closed\|This probably\|before or while\|connection to server\|terminated'
pg_ctl -D $PWD/rc -m immediate stop >/dev/null 2>&1
rm -rf $M $PWD/rc
