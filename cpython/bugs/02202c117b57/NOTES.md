repro.py ports test_clear_at_lookup: a key whose __eq__ calls d.clear() during lookup, inserted repeatedly via d[k]=v and d.setdefault.
Clean: prints 1 and 1, exit 0. Buggy: the dict is cleared mid-lookup, so the keys kind is wrong; a debug assertion (PyUnicode_Check) fails and the process aborts (exit -6).
