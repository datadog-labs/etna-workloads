compile_file with PathLike stripdir (quiet=2): the buggy build no longer calls os.fspath on stripdir, so it raises an AttributeError; the clean build returns True.
