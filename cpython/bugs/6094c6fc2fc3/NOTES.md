Writes one record to a RotatingFileHandler (maxBytes=1, backupCount=1) with an empty log file.
Clean: no rollover of an empty file (gh-116263), directory is ['x.log'].
Buggy: the empty-file check is removed, so it rolls over and creates 'x.log.1' too.
