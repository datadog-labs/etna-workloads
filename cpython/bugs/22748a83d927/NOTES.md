Creates a gzip stream tarfile ("w|gz") at sub/out.tar.gz and checks whether the
directory name leaks into the gzip FNAME header field. Clean prints False;
buggy prints True (os.path.basename removal missing in _Stream._init_write_gz).
