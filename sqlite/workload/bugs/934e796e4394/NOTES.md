Reproducer (repro.sql): the join2-13 case. A LEFT JOIN to t3 is dropped by the
Omit-Noop-Join optimization, and the reverse-order bit for t2 (ORDER BY d2 DESC)
in WhereInfo.revMask is not shifted in the buggy build.

Clean shell prints `33|2` then `33|1`. Buggy shell prints `33|1` then `33|2`
(wrong ORDER BY DESC result). Exit status is 0 on both.
