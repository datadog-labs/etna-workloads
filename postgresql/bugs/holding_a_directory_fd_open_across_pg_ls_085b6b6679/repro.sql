SELECT pg_ls_waldir() IS NOT NULL LIMIT 1;
SELECT count(*) > 0 AS ok FROM (SELECT pg_ls_waldir() LIMIT 1) s;
