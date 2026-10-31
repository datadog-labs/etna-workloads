repro.py calls shutil.copytree with a custom copy_function that prints the type and value of its arguments.
Clean: the function receives plain str paths (`str str`, `src/foo dst/foo`).
Buggy: the source argument is an os.DirEntry (`DirEntry str`, `<DirEntry 'foo'> dst/foo`), because injection.patch passes srcentry instead of srcobj.
