CREATE COLLATION ci (provider = icu, locale = 'und-u-ks-level2', deterministic = false);
SELECT replace('testX' COLLATE ci, 'x' COLLATE ci, 'er');
