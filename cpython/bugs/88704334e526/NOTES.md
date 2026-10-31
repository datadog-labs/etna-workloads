Calls shutil.copytree with a pathlib.Path source and an ignore callback that prints the argument types.
Clean: ignore gets (str, list). Buggy: gets (PosixPath, set).
