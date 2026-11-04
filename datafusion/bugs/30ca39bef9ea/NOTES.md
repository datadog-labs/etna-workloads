repro.sql calls regexp_count with a NULL regex, both as a scalar and as a column value, and also with a NULL flags argument. It also calls regexp_instr with a NULL regex.

On the clean build, regexp_count returns NULL whenever the regex or flags is NULL. On the buggy build it returns 0 for a NULL regex, and for a NULL scalar flags it counts as if there were no flags (`b` is 1 instead of NULL). The regexp_instr queries gave the same output on both builds.
