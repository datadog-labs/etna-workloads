repro.sh: on a file database, disables ATTACH_WRITE (`.dbconfig attach_write 0`), sets page_size=4096, runs VACUUM, prints page_size.
Clean shell: VACUUM succeeds, exit 0. Buggy shell: VACUUM fails with "attempt to write a readonly database" (VACUUM no longer re-enables AttachCreate/AttachWrite for its internal temp-db ATTACH), exit 1.
