Reproducer: a `logging.LoggerAdapter(logger, merge_extra=True)` with no adapter `extra`, logging with a per-call `extra`.
Clean: the records are emitted normally (prints `with extra True`, `no extra False`).
Buggy: `process()` does `{**None, ...}`, so the first call raises `TypeError: 'NoneType' object is not a mapping`.
