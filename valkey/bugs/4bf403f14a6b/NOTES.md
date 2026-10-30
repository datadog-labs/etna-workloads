WATCH a stream key on one connection, then another client runs XGROUP CREATECONSUMER on it, then the first runs MULTI/PING/EXEC.
Clean: EXEC returns nil (key dirtied). Buggy: EXEC runs and returns PONG (signalModifiedKey missing).
