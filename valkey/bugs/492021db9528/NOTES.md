Blocks a client on `BLPOP mylist 1`, then (~0.3s later) sends MULTI/RPUSH/PEXPIRE 100/DEBUG SLEEP 0.2/EXEC
with active expire off. The push wakes the client, but the key has expired, so the command is reprocessed
and blocks again. Clean build keeps the original 1s deadline (total ~1.0s -> "timeout retained");
buggy build resets the timeout in blockForKeys (total ~1.5s -> "timeout reset"). Threshold is 1400ms.
