Table with INT affinity and a NOCASE unique index holds the text './'.
`c0 LIKE './'` should return './'. In the buggy build the LIKE optimization
is applied without the check that the pattern prefix boundaries don't look
numeric (here './' -> '.0' bound is parsed as a number), so the range
scan misses the row and the query returns nothing. Clean shell returns './'.
