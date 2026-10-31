repro.py replaces multiprocessing.Manager with a stub that records calls, then configures a
QueueHandler with a plain queue.Queue via logging.config.dictConfig.
Clean: prints 0 (no Manager created). Buggy: _is_queue_like_object eagerly calls
multiprocessing.Manager(), so the stub is hit and dictConfig raises ValueError (exit 1).
