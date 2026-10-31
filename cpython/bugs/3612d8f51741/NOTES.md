Builds an in-memory tar with a symlink `d/esc -> a/../../outside` (where `d/a -> sub`) and runs
`tarfile.data_filter` on each member. The fix makes the data filter normalize symlink targets
(`os.path.normpath`). Clean prints the normalized linkname `'../outside'`; buggy leaves it
unnormalized as `'a/../../outside'`, so the filter's check and the real filesystem resolution can disagree.
