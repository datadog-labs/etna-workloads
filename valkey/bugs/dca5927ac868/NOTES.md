Reproducer for the tracking invalidation queue bug (#11814/#11715).
repro.sh sets tracking-table-max-keys 2, pauses cron, and on a raw RESP3 connection enables
tracking, MGETs 2 keys and starts MULTI. It then lowers the limit to 1 from another client and
sends PING (queued) + EXEC. Evicting keys before the queued command schedules the invalidation
in tracking_pending_keys, which is never drained.
Clean: server stays up, final PING answers PONG. Buggy: server hits an assertion and aborts, so
the CLI cannot connect and the script prints ASSERTION.
