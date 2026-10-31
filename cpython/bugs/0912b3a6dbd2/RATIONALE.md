# Rationale

Hunk changed: `Lib/multiprocessing/forkserver.py`, `ForkServer.ensure_running`.

The fix replaced the lookup of the stale key `main_path` in
`spawn.get_preparation_data()` output with `init_main_from_path` (the key was
renamed). In v3.15.2 the fixed lookup is still present (alongside later
`sys_argv`/`on_error` code). I restored the pre-fix lookup: `if 'main_path' in
data: main_kws['main_path'] = data['main_path']`. Since the key is never
produced, `main_path` is never passed to the forkserver, so `__main__` is not
pre-loaded in the forkserver and each child re-imports it as `__mp_main__`.

Failing oracle case: `MiscTestCase.test_preload_main` — output is
`['__main__', '__mp_main__', 'f', '__mp_main__', 'f', '']` instead of
`['__main__', '__mp_main__', 'f', 'f', '']`.
