`repro.py` calls `transport.writelines()` with 4 MiB on a real socketpair with tiny buffers, then reads from the peer.

Clean: `writelines` leaves a partial write buffered and registers a writer, so all data arrives.
Buggy: the writer is never registered after a partial send, so the data stalls. The reader times out after 3s and prints `received all: False`.
