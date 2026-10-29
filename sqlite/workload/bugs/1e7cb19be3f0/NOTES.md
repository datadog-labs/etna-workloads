repro.sql mirrors window1-19.2.2: a table mixing integers and strings, queried with
`sum(b) OVER (ORDER BY a DESC RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING)`.

Clean shell: each row sums only its numeric neighbours (1|3, 2|6, ... a|6, e|10).
Buggy shell: the injection removes the check that skips the add/subtract when the
ORDER BY value is a string or blob, so every row gets 55, the sum of the whole table.
