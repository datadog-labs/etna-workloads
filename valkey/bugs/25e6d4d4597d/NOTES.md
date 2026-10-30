Starts a server with appendonly yes and an appendfilename containing spaces and newlines, runs BGREWRITEAOF, then DEBUG LOADAOF and compares digests, and dumps the manifest with `cat -A`.
Clean: the filename is written in escaped (repr) form on one line, and loadaof succeeds (digest-match).
Buggy: the filename is written raw, so the manifest has literal newlines. Reloading it fails and the server exits (digest-mismatch).
