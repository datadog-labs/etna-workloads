# Rationale

Changed `Lib/threading.py`: removed `_DummyThread._after_fork`, which the fix
(gh-102512) added. It is the only implementation hunk with behaviour. The
v3.15.2 version already differs slightly from the fix (no `_set_tstate_lock`,
since thread handles replaced tstate locks), so a plain reverse patch does not
apply. Deleting the whole override restores the pre-fix behaviour: after
`os.fork()` from a foreign thread, a `_DummyThread` that already exists stays a
`_DummyThread` (name `Dummy-N`, daemonic) instead of becoming `_MainThread`.

Failing oracle case: `test_main_thread_after_fork_from_dummy_thread`. In the
child, `main_thread()` is `Dummy-1 _DummyThread` instead of
`MainThread _MainThread`, and `_dangling` is `['Dummy-1']`.
