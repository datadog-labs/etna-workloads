#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set foo bar
# RESTORE with a relative TTL that overflows once basetime is added
c eval "local p=server.call('dump',KEYS[1]) server.call('del',KEYS[1]) local r=server.pcall('restore',KEYS[1],'9223372036854775807',p) if r.err then return r.err end return 'restored'" 1 foo
c exists foo
c shutdown nosave
wait
