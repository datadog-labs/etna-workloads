repro.py installs a `sys.setprofile` hook, then runs `next(f())` on a generator that is left unfinished. When the generator is garbage collected, it is closed via a PY_THROW, which should produce an extra `call` profile event.

- Clean: `[('call', None), ('return', 0), ('call', None), ('return', None)]`
- Buggy: `[('call', None), ('return', 0), ('return', None)]` (the second `call` event is missing)

`./check.sh` fails in this sandbox (bwrap can't find `.claude/launch.json`), so I ran both interpreters by hand in an empty temp directory.
