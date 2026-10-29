repro.sh creates a db in a directory, makes the directory read-only (chmod 555), then
reads and inserts. The journal can't be created in the read-only directory.
Clean: "attempt to write a readonly database" (SQLITE_READONLY_DIRECTORY).
Buggy: "unable to open database file" (SQLITE_CANTOPEN) instead.
