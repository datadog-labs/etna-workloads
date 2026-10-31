repro.py: a generator calls next() on a tee copy of itself while the lead tee iterator is fetching from it.
Clean: RuntimeError "cannot re-enter the tee iterator" (the `running` guard in teedataobject).
Buggy: no guard, so the call reaches the generator and raises ValueError "generator already executing" (with a traceback).
