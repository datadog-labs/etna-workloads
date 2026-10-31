repro.py builds a tar in memory (regular file + hardlink to it), pre-creates `ustar/lnktype` as a symlink to a file `target`, then extracts both members with filter="data".
Clean: the symlink is unlinked and replaced by a hardlink; `target` stays b'target'.
Buggy: the symlink is followed, so `target` is overwritten with b'regtype content'.
