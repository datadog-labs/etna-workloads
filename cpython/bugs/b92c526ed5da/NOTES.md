Reloads `stat` with the C `_stat` module blocked (so the pure-Python `filemode` is used) and prints
`stat.filemode(S_IFSOCK | 0o755)`.
Clean: `'srwxr-xr-x'`. Buggy (S_IFSOCK entry removed from the table): `'?rwxr-xr-x'`.
