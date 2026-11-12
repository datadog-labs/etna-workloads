SELECT strftime(ci.purchasedate.nullif('1899-12-30T00:00:00'), '%Y-%m-%d')
FROM (VALUES (TIMESTAMP '2026-01-01')) AS ci("PurchaseDate");
