#!/bin/bash
# Reproducer for BITOP memory-corruption bug (missing `minlen = 0` reset
# when a source key is missing, re-introduced by injection.patch).
#
# When one of the BITOP source keys does not exist, `len[j]` is set to 0
# for that key, but `minlen` (the common length used to drive the fast
# "whole word" copy/merge loop) must also be reset to 0 so that the fast
# path is skipped. Without that reset, BITOP can read past the end of the
# existing (shorter) source buffers whenever a later key is missing,
# corrupting memory and crashing the server.

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &

until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do
    sleep 0.1
done

c() { "$VALKEY_CLI" -p "$PORT" "$@"; }

# A source string long enough to take the fast (word-at-a-time) path in
# bitopCommand(), combined with a non-existent second source key.
c set s "0123456789012345678901234567890123456789"
c bitop or x s nokey
c strlen x
c bitop and y s nokey
c strlen y

c shutdown nosave >/dev/null 2>&1
wait 2>/dev/null

if grep -q "crashed by signal\|Segmentation fault" s.log; then
    echo CRASH
fi
