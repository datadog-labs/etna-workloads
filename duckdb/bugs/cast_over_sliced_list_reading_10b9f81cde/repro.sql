.mode list
.nullvalue NULL
WITH t(l) AS (VALUES ([['bad'], ['1', '2'], ['3', '4']]), ([['bad'], ['5', '6'], ['7', '8']]))
SELECT CAST(list_slice(l, 2, 3) AS INTEGER[][2]) FROM t;
