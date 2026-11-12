.mode list
.nullvalue NULL
SELECT list_select(TRY_CAST(l AS UUID[]), [2, 1]), list_where(TRY_CAST(l AS UUID[]), [true, false]) FROM (SELECT [1, 2, 3] l);
