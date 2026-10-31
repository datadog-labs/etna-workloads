repro.py creates a script whose filename contains an undecodable byte (\xff) and calls
sys.remote_exec() on the current process with it, as bytes and as a surrogateescape str.
Clean: the script runs and prints "Remote script executed successfully!" for both.
Buggy: sys.remote_exec raises UnicodeEncodeError (path is converted with UTF-8 instead of the filesystem encoding).
