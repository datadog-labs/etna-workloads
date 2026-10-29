repro.sql runs the fts3aa-8.x scenario. An fts4(order=desc) table gets an insert, a docid update (1 -> 5) and another insert (docid 6) in one transaction. It then runs MATCH 'abc' before and after COMMIT.

Clean shell: both queries return 6, 5.
Buggy shell: fts3ReversePoslist() mishandles the first poslist in a doclist. The pre-COMMIT query returns 6, 5, 1 and the post-COMMIT query returns 6, 1. The deleted docid 1 shows up and docid 5 goes missing. Both shells exit 0.
