Calls pkgutil.get_importer() and iter_modules() with pathlib.Path objects.
Clean: works (returns FileFinder / empty list). Buggy: get_importer no longer
fsdecodes the path, so zipimporter raises TypeError (expected str, not PosixPath).
