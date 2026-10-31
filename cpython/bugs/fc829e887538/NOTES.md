Builds a zip with `good..file`, `C:/abspath`, `/abs`, `../rel` and unpacks it with shutil.unpack_archive.
Clean: `good..file` is extracted (only names that are really `..` components are skipped).
Buggy: the old shutil code skips any name containing `..`, so `good..file` is missing; `C:/abspath` handling also differs.
