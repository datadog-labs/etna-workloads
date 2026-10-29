`repro.sql` runs `substr('abcdefghijklmnop', -1000000000000000)` (two-argument form, hugely negative start).
Clean shell prints `abcdefghijklmnop`. The buggy shell prints an empty string, because the implicit length is capped at SQLITE_LIMIT_LENGTH instead of LARGEST_INT64, so the start-offset adjustment eats the whole length.
(`./check.sh` failed in the sandbox with a bwrap error, so I compared the two shells by running them directly.)
