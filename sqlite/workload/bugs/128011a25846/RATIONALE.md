# Rationale

Fix: zipfile problem adding directories (ext/misc/zipfile.c). In 3.54.1 the logic is in `zipfileGetMode()`, which takes `bIsDir`.

Both changes are in `zipfileGetMode()`:

1. Default mode when `mode` is NULL: reverts the fix's `mode = defaultMode` (dir => `S_IFDIR+0755`) to the old unconditional `S_IFREG + 0644`. A directory inserted with only `(name, data=NULL)` now gets a regular-file mode.
2. Removed the `((mode & S_IFDIR)==0)==bIsDir` mismatch check ("mode does not match data"), which the fix added (`bIsDir == ((mode & S_IFDIR)==0)` -> SQLITE_CONSTRAINT). Pre-fix had no such check. It must go too, otherwise change 1 would turn into a constraint error rather than the wrong mode.

The `bIsDir` parameter is left in the signature, unused.

## Oracle failures
test/zipfile.test: zipfile-2.2 / 2.4 (directory entries report mode 33188 instead of 16877), plus later cases that unzip the resulting archive (the directory is created as a file, so extracting its children fails) and 99 of 145 in total due to the aborted run.
