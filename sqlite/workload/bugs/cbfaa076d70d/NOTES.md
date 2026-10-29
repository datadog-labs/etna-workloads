Creates subdir/ with two files, then runs `SELECT name FROM d JOIN x JOIN fsdir('.', d)`.
The buggy fsdirBestIndex ignores that the `dir` constraint is not usable, so the
plan is wrong. Clean prints `.`, `./x1.txt`, `./x2.txt`; buggy differs (see ./check.sh).
