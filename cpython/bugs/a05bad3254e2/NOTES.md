Opens a blob with rowid 2**32 via `Connection.blobopen`. Clean build returns the blob (reads `b'\x00'`); buggy build truncates the rowid to int and raises OverflowError.
