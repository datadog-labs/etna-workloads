`repro.sql` runs `SELECT char(448) LIKE '%' || char(128)` (U+01C0 vs pattern `%U+0080`, like-3.1 in test/like2.test).
Clean shell prints 0 (correct). Buggy shell prints 1, because the injected `c<=0x80` (instead of `c<0x80`) in patternCompare() takes the single-byte fast path for U+0080 after a `%` wildcard.
