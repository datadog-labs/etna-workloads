#!/bin/sh
# Run a reproducer against an installed PostgreSQL build in a fresh private cluster.
# usage: repro_run.sh INSTALL_BINDIR REPRO_FILE OUTFILE
# REPRO_FILE: *.sql (run with psql -X -a, ON_ERROR_STOP off) or *.sh (run with sh; env has PATH,
# PGHOST, PGPORT, PGDATABASE=postgres, PGDATA).  Writes normalised combined output to OUTFILE and
# exits with the reproducer's status (psql/sh), or 99 if the server died.
set -u
BIN=$(cd "$1" && pwd); REPRO=$(cd "$(dirname "$2")" && pwd)/$(basename "$2"); OUT=$(cd "$(dirname "$3")" && pwd)/$(basename "$3")
W=$(mktemp -d "${TMPDIR:-/tmp}/repro.XXXXXX")
export PATH="$BIN:/usr/bin:/bin" PGHOST="$W" PGPORT=5432 PGDATABASE=postgres PGDATA="$W/data" LC_ALL=C.UTF-8
unset PGUSER PGPASSWORD PGSERVICE PGOPTIONS
LIB=$(cd "$BIN/../lib" && pwd); export LD_LIBRARY_PATH="$LIB"
initdb -A trust -N --no-instructions -E UTF8 --locale=C.UTF-8 "$PGDATA" >"$W/initdb.log" 2>&1 || { echo "initdb failed" >"$OUT"; cat "$W/initdb.log" >>"$OUT"; rm -rf "$W"; exit 98; }
cat >>"$PGDATA/postgresql.conf" <<CONF
listen_addresses = ''
unix_socket_directories = '$W'
fsync = off
max_prepared_transactions = 10
log_min_messages = warning
CONF
pg_ctl -w -t 60 -l "$W/server.log" start >/dev/null 2>&1 || { echo "server start failed" >"$OUT"; rm -rf "$W"; exit 97; }
cd "$W"
case "$REPRO" in
  *.sql) timeout 300 psql -X -a -q -v ON_ERROR_STOP=0 -f "$REPRO" >"$W/out.raw" 2>&1; rc=$? ;;
  *)     timeout 300 sh "$REPRO" >"$W/out.raw" 2>&1; rc=$? ;;
esac
alive=1; pg_ctl status >/dev/null 2>&1 || alive=0
grep -q 'terminated by signal\|was terminated by\|TRAP:' "$W/server.log" && alive=0
pg_ctl -m immediate stop >/dev/null 2>&1
# normalise machine/build-local paths and pids
sed -e "s#$W#<WORK>#g" -e "s#$BIN#<BIN>#g" -e "s#$REPRO#<REPRO>#g" \
    -e 's/pid [0-9][0-9]*/pid <PID>/g' "$W/out.raw" >"$OUT"
[ $alive = 1 ] || { echo "### server crashed or assertion failed" >>"$OUT"; rc=99; }
rm -rf "$W"
exit $rc
