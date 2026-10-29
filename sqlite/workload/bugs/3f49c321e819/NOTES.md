Window RANGE frame `BETWEEN 7 PRECEDING AND 2 PRECEDING` (window8-6.2). The injection removes the
special ordering of AGGINVERSE before RETURN_ROW for RANGE PRECEDING..PRECEDING frames, so
rows get wrong group_concat results. Clean expected: `(empty) A.B A.B`; buggy differs.
