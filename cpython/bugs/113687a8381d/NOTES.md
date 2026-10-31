repro.py creates a.log.<ts>, a.log.b.<ts> and a.log.<ts>.c, then calls getFilesToDelete() on a
TimedRotatingFileHandler for 'a.log' (backupCount=1).
Clean: [] (only one real backup exists, so nothing to delete).
Buggy: also counts a.log.<ts>.c (the extension-stripped prefix/loose match), so it returns
['a.log.<ts>', 'a.log.<ts>.c'].
