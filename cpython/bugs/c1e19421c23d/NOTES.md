Writes a GNU-format tar in memory with a directory member whose name is 101 'a's plus a trailing '/' (forces a GNU longname record), then reads it back.
Clean: the name has the trailing slash stripped, so getmember('a'*101) works and prints True.
Buggy: the injection removes the slash stripping in `_proc_gnulong`, so the name keeps its '/' and getmember('a'*101) raises KeyError.
