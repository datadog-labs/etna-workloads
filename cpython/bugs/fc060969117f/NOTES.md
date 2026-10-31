Reproducer for dbm.dumb: opening a db with 'c'/'n' should create the .dir file immediately, and sync() should mark the db unmodified.
Clean prints True/True/False/False/False-style output (.dir exists after open; not recreated by a second sync/close).
Buggy: .dir isn't created on open, and sync() doesn't clear the modified flag, so .dir is rewritten on later sync/close.
