repro.sql runs generate_series() with non-integer float constraints on `value`.
The buggy shell truncates the float to an integer, so `value>=5.5` also returns 5
(5..10 instead of 6..10, and 10..5 instead of 10..6 in descending order), and
`value==5.5` returns row 5 instead of no rows. The clean shell returns the correct rows.
