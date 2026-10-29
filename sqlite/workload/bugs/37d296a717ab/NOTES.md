Reproducer (repro.sql, from windowB-6.1): a RANGE frame `BETWEEN 2 FOLLOWING AND 0 FOLLOWING`
(start after end) over an indexed column mixing integers and text.

Clean shell: returns `7|`, `8|`, `abc|1001`.
Buggy shell: aborts with `sumInverse: Assertion 'p->cnt>0' failed` (exit -6), because the
injection removes the check that stops the start cursor passing the end cursor, so the
inverse step runs on rows never added.
