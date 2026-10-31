Writes a ConfigParser containing a key with a delimiter ("a=b") and a key matching the section header pattern.
Clean: write() raises InvalidWriteError for both. Buggy: the validation is missing, so write() silently emits the unreadable output.
