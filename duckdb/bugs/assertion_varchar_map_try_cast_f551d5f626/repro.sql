.mode list
.nullvalue NULL
SELECT TRY_CAST('{null=1,k=2}' AS MAP(VARCHAR, INTEGER));
