#!/usr/bin/env bash
# Reproducer for: rdbLoadObject() accepting RESTORE payloads that declare
# a length of 0 for aggregate types (hash, zset, set, list, ...) and
# silently creating an empty key, instead of rejecting the payload with
# "Bad data format".
#
# Fixed upstream by commit 8ea777a6a02cae22aeff95f054d810f30b7b69ad
# ("Sanitize dump payload: fix empty keys when RDB loading and restore
# command (#9297)"), which adds "if (len == 0) goto emptykey;" checks in
# rdbLoadObject() right after the length is read for RDB_TYPE_HASH,
# RDB_TYPE_SET, RDB_TYPE_ZSET_2, RDB_TYPE_LIST, etc.
#
# This translates two of the upstream regression tests added by that fix
# (tests/integration/corrupt-dump.tcl):
#   "corrupt payload: fuzzer findings - hash with len of 0"
#   "corrupt payload: fuzzer findings - empty zset"
# Both RESTORE a minimal hand-crafted payload (type byte + a length field
# that decodes to 0 + a version/footer) with checksum validation disabled
# via DEBUG SET-SKIP-CHECKSUM-VALIDATION, since the payloads don't carry
# a valid CRC64.
#
# The payloads contain NUL bytes, so they can't be passed as a plain
# valkey-cli argument (argv is NUL-terminated) -- they are sent as raw
# RESP over a /dev/tcp socket instead.
#
# On the clean (fixed) build both RESTORE calls must be rejected with
# "Bad data format" and the keys must not exist. On the buggy build
# RESTORE succeeds and empty keys are created.

set -u

LOG="s.log"

cleanup() {
    "$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
}
trap cleanup EXIT

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --logfile "$LOG" --enable-debug-command yes &

for _ in $(seq 1 100); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

"$VALKEY_CLI" -p "$PORT" debug set-skip-checksum-validation 1 >/dev/null

# RESTORE hashkey 0 "\x04\xC0\x21\x09\x00\xF6\x8A\xB6\x7A\x85\x87\x72\x4D"
# type=RDB_TYPE_HASH, declared length decodes to 0.
exec 3<>"/dev/tcp/127.0.0.1/$PORT"
printf '*4\r\n$7\r\nRESTORE\r\n$7\r\nhashkey\r\n$1\r\n0\r\n$13\r\n\x04\xC0\x21\x09\x00\xF6\x8A\xB6\x7A\x85\x87\x72\x4D\r\n' >&3
IFS= read -r -t 5 -u 3 reply1
exec 3<&-
echo "restore hash len=0: ${reply1:-<no reply>}"
echo "exists hashkey: $("$VALKEY_CLI" -p "$PORT" exists hashkey)"

# RESTORE zsetkey 0 "\x05\xC0\x01\x09\x00\xF6\x8A\xB6\x7A\x85\x87\x72\x4D"
# type=RDB_TYPE_ZSET_2, declared length decodes to 0.
exec 3<>"/dev/tcp/127.0.0.1/$PORT"
printf '*4\r\n$7\r\nRESTORE\r\n$7\r\nzsetkey\r\n$1\r\n0\r\n$13\r\n\x05\xC0\x01\x09\x00\xF6\x8A\xB6\x7A\x85\x87\x72\x4D\r\n' >&3
IFS= read -r -t 5 -u 3 reply2
exec 3<&-
echo "restore zset len=0: ${reply2:-<no reply>}"
echo "exists zsetkey: $("$VALKEY_CLI" -p "$PORT" exists zsetkey)"

echo "dbsize: $("$VALKEY_CLI" -p "$PORT" dbsize)"
echo "ping: $("$VALKEY_CLI" -p "$PORT" ping)"
