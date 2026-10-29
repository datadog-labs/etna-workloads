`DROP TABLE dbstat;` on an eponymous virtual table.
Clean shell: "Error: table dbstat may not be dropped". Buggy shell: silently succeeds (no error).
