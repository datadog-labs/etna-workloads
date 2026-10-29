`repro.sql` runs `ATTACH NULL AS NULL` and `DETACH NULL` (ticket #1825).

- Clean shell: a NULL file or database name is treated as an empty string. The attach and the first detach succeed, and the second detach gives "no such database: ".
- Buggy shell: `injection.patch` removes the NULL-to-"" defaults, so `attachFunc` hits `assert(zName)` and the shell aborts (exit status -6).
