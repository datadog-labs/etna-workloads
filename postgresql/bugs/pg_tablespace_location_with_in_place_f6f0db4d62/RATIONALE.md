# Rationale
File: src/backend/utils/adt/misc.c, function pg_tablespace_location().
Traces to the fix_impl.patch hunks that add the lstat()/S_ISLNK check and the `struct stat st` declaration. I removed both (the sys/stat.h include is left; it's harmless).
Effect: for an in-place tablespace (a real directory in pg_tblspc/<oid>), readlink() fails with EINVAL, so the function errors ("could not read symbolic link") instead of returning the relative path pg_tblspc/<oid>.

Failing oracle case: src/test/regress||tablespace
