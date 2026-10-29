Reproducer for the LEFT JOIN eliminator bug (join2-4.3.0/4.3.1): a LEFT JOIN on a
WITHOUT ROWID table `b` that is unused gets dropped, but terms depending on it
aren't marked coded / notReady isn't updated. The buggy shell asserts or returns
wrong rows; the clean shell returns the correct result.
